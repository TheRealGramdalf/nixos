{ config, lib, pkgs, ... }:

with lib;

let
  inherit (lib.types) nullOr bool int float str lazyAttrsOf listOf path;
  inherit (lib) optional getExe;
  cfg = config.services.traefik;

  jsonValue = nullOr (oneOf [
    bool
    int
    float
    str
    (lazyAttrsOf valueType)
    (listOf valueType)
  ]) // {
    description = "JSON value";
    emptyValue.value = { };
  };
  dynamicConfig.file = if cfg.dynamicConfigFile == null then
    ${
      pkgs.writeText "dynamic_config.json"
      (builtins.toJSON cfg.dynamicConfigOptions)
    }
  else
    cfg.dynamicConfig.file;
  staticConfigFile = if cfg.staticConfigFile == null then
    ${
      pkgs.writeText "static_config.json" (builtins.toJSON
        (recursiveUpdate cfg.staticConfigOptions {
          providers.file.filename = "${dynamicConfigFile}";
        }))
    }
  else
    cfg.staticConfig.file;

  finalStaticConfigFile =
    if cfg.environmentFiles == []
    then staticConfig.file
    else "/run/traefik/config.toml";
in {
  options.services.cone = {
    enable = mkEnableOption "Traefik web server";

# TODO
# - [?] inherit lib.types, remove `with`
# - [] Figure out dynamic folder logic/assertions
# - [] Add "virtualHosts" convenience feature?
# - [] Remove `config` from static/dynamic
# - [] Fix defaultText, example (replace with `'' ''`), etc.
# - [] Fix tmpfiles rules, readWritePaths
# - [] Follow caddy for user creation (don't assume it's always created)
# - [] Use statix?
# - [] If using virtualHost, make it top level (services.traefik.virthosts), and make it a convenience function. Make it assert conflictions with dynamic file
# - [] Replace default text with clear logic examples
# - [] check rfc 42
# - [] Make virtualhost use a different mechanism (tmpfiles?) to create dynamic config, so that the systemd service doesn't need to be restarted (the service definition isn't changed)
#   if simply using `nixos-rebuild switch` (for minimal downtime).
# - [] Check docker, see if running a standalone binary works with the docker backend. If not, note the pitfalls
# - [] Add descr. for options used by the module
# - [] nixos Tests?
# - [] Package pinning?
# - [] Configuration test via https://github.com/traefik/traefik/issues/10804 (need to grab schema from traefik pkg, add schema output to traefik pkg)
    staticConfig = {
      file = mkOption {
        default = null;
        example = literalExpression "/path/to/static_config.toml";
        type = nullOr path;
        description = ''
          Path to traefik's static configuration to use.
          (Using this option has precedence over `staticConfigOptions` and `dynamicConfigOptions`)
        '';
      };
      settings = mkOption {
        description = ''
          Static configuration for Traefik, written in nix
        '';
        type = jsonValue;
        default = { entryPoints.http.address = ":80"; };
        example = {
          entryPoints.web.address = ":8080";
          entryPoints.http.address = ":80";

          api = { };
        };
      };
    };

    

    dynamicConfig = {
      file = mkOption {
        default = null;
        example = literalExpression "/path/to/dynamic_config.toml";
        type = nullOr path;
        description = ''
          Path to traefik's dynamic configuration to use.
          (Using this option has precedence over `settings`)
        '';
      };
      dir = mkOption {
        default = null;
        example = literalExpression "/path/to/dynamic_config_folder";
        type = nullOr path;
        description = ''
          Path to the directory traefik should watch.
          (Using this option has precedence over `settings`)
        '';
      };

      settings = mkOption {
        description = ''
          Dynamic configuration for Traefik, written in nix.
        '';
        type = jsonValue;
        default = { };
        example = {
          http.routers."router1" = {
            rule = "Host(`localhost`)";
            service = "service1";
          };

          http.services."service1".loadBalancer.servers =
            [{ url = "http://localhost:8080"; }];
        };
      };
    };

    dataDir = mkOption {
      default = "/var/lib/traefik";
      type = path;
      description = ''
        Location for any persistent data traefik creates, ie. acme
      '';
    };

    group = mkOption {
      default = "traefik";
      type = str;
      example = "docker";
      description = ''
        Set the group that traefik runs under.
        For the docker backend this needs to be set to `docker` instead.
      '';
    };

    package = mkPackageOption pkgs "traefik" { };

    environmentFiles = mkOption {
      default = [];
      type = listOf path;
      example = [ "/run/secrets/traefik.env" ];
      description = ''
        Files to load as environment file. Environment variables from this file
        will be substituted into the static configuration file using envsubst.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [ "d '${cfg.dataDir}' 0700 traefik traefik - -" ];

    systemd.services.traefik = {
      description = "Traefik web server";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      startLimitIntervalSec = 86400;
      startLimitBurst = 5;
      serviceConfig = {
        EnvironmentFile = cfg.environmentFiles;
        ExecStartPre = optional (cfg.environmentFiles != [])
          (pkgs.writeShellScript "pre-start" ''
            umask 077
            ${getExe pkgs.envsubst} -i "${staticConfigFile}" > "${finalStaticConfigFile}"
          '');
        ExecStart = "${getExe cfg.package} --configfile=${finalStaticConfigFile}";
        Type = "simple";
        User = "traefik";
        Group = cfg.group;
        Restart = "on-failure";
        AmbientCapabilities = "cap_net_bind_service";
        CapabilityBoundingSet = "cap_net_bind_service";
        NoNewPrivileges = true;
        LimitNPROC = 64;
        LimitNOFILE = 1048576;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHome = true;
        ProtectSystem = "full";
        ReadWritePaths = [ cfg.dataDir ];
        RuntimeDirectory = "traefik";
      };
    };

    users.users.traefik = {
      group = "traefik";
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
    };

    users.groups.traefik = { };
  };
}
