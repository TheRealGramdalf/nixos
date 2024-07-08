{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.types) nullOr bool int float str lazyAttrsOf listOf path literalExpression oneOf attrsOf submodule;
  inherit (lib) optional optionals getExe mkIf optionalAttrs recursiveUpdate mkOption mkEnableOption mkPackageOption mapAttrsToList;
  inherit (builtins) toJSON;
  inherit (pkgs) writeText;
  cfg = config.services.cone;
  jsonValue = let
    valueType =
      nullOr (oneOf [
        bool
        int
        float
        str
        (lazyAttrsOf valueType)
        (listOf valueType)
      ])
      // {
        description = "JSON value";
        emptyValue.value = {};
      };
  in
    valueType;

  dynamicFile =
    if (cfg.dynamic.file == null && cfg.dynamic.dir == null)
    then (builtins.toJSON cfg.dynamic.settings)
    else cfg.dynamic.file;

  staticFile =
    if cfg.static.file == null
    then (builtins.toJSON cfg.static.settings)
    else cfg.static.file;

  finalStaticFile =
    if cfg.environmentFiles == []
    then staticFile
    else "/run/traefik/config.json";

  configNote = ''
    ::: {.note}
    Traefik config is serialized to JSON, which is considered valid YAML since 1.2
    :::
  '';
in {
  options.services.cone = {
    # TODO
    # - [x] inherit lib.types, remove `with`
    # - [] Figure out dynamic folder logic/assertions
    # - [] Add "virtualHosts" convenience feature?
    # - [x] Remove `config` from static/dynamic
    # - [] Fix defaultText, example (replace with `'' ''`), etc.
    # - [?] Fix tmpfiles rules, readWritePaths
    # - [x] Follow caddy for user creation (don't assume it's always created)
    # - [] Use statix?
    # - [] If using virtualHost, make it top level (services.traefik.virthosts), and make it a convenience function. Make it assert conflictions with dynamic file
    # - [] Replace default text with clear logic examples
    # - [] check rfc 42 https://github.com/NixOS/rfcs/blob/master/rfcs/0042-config-option.md
    # - [] Make virtualhost use a different mechanism (tmpfiles?) to create dynamic config, so that the systemd service doesn't need to be restarted (the service definition isn't changed)
    #   if simply using `nixos-rebuild switch` (for minimal downtime).
    # - [] Check docker, see if running a standalone binary works with the docker backend. If not, note the pitfalls
    # - [] Add descr. for options used by the module
    # - [] nixos Tests?
    # - [] Package pinning?
    # - [] Configuration test via https://github.com/traefik/traefik/issues/10804 (need to grab schema from traefik pkg, add schema output to traefik pkg)
    # - [x] Remove `createHome` and `homeDir`, use systemd tmpfiles instead
    # - [] Use `note` syntax
    # - [] https://github.com/NixOS/nixpkgs/blob/6fd558c210c90f72c8116a0ea509f4280356d2bb/nixos/modules/services/web-servers/caddy/default.nix#L345C5-L345C63

    # CHANGELOG
    # - Removed usage of `with`, replacing it with `inherit` instead
    # - Do not always assume the systemd user must be created by NixOS
    # - Rename options to be more ergonomic and in line with the spirit of RFC 42
    # - (minimal downtime)
    enable = mkEnableOption "Traefik web server";
    static = {
      file = mkOption {
        default = null;
        example = literalExpression "/path/to/static_config.toml";
        type = nullOr path;
        description = ''
          Path to traefik's static configuration to use.
          (Using this option has precedence over `staticOptions` and `dynamicOptions`)
        '';
      };
      settings = mkOption {
        description = ''
          Static configuration for Traefik, written in nix
        '';
        type = jsonValue;
        default = {entryPoints.http.address = ":80";};
        example = {
          entryPoints.web.address = ":8080";
          entryPoints.http.address = ":80";

          api = {};
        };
      };
    };

    dynamic = {
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
        example = literalExpression "/run/traefik/dynamic-config";
        type = nullOr path;
        description = ''
          Path to the directory traefik should watch.
        '';
      };

      settings = mkOption {
        description = ''
          Dynamic configuration for Traefik, written in nix.
        '';
        type = jsonValue;
        default = {};
        example = {
          http.routers."router1" = {
            rule = "Host(`localhost`)";
            service = "service1";
          };

          http.services."service1".loadBalancer.servers = [{url = "http://localhost:8080";}];
        };
      };
    };

    extraFiles = mkOption {
      type =
        attrsOf
        (submodule {
          options.settings = mkOption {
            type = jsonValue;
            description = "Dynamic configuration for Traefik, written in nix.";
            example = {
              traefik.http.routers."api".service = "api@internal";
              traefik.http.services."api".loadbalancer.server.port = 8080;
            };
          };
          options.name = mkOption {
            type = path;
            description = "The mount point of the directory inside the virtual machine";
          };
        });
      default = {};
      example = {
        "dashboard".settings = {
          traefik.http.routers."api".service = "api@internal";
          traefik.http.services."api".loadbalancer.server.port = 8080;
        };
      };
      description = ''
        Extra dynamic configuration files to write. These are placed in `cfg.dynamic.dir` upon activation.
        This allows configuration to be upated without restarting the primary daemon, which would cause interruptions.
      '';
    };

    dataDir = mkOption {
      default = "/var/lib/traefik";
      type = path;
      description = ''
        Location for any persistent data traefik creates, such as acme certificates

        ::: {.note}
        If left as the default value this directory will automatically be created
        before the traefik server starts, otherwise you are responsible for ensuring
        the directory exists with appropriate ownership and permissions.
        :::
      '';
    };

    user = mkOption {
      default = "traefik";
      type = str;
      description = ''
        Group under which traefik runs.

        ::: {.note}
        If left as the default value this user will automatically be created
        on system activation, otherwise you are responsible for
        ensuring the user exists before the traefik service starts.
        :::
      '';
    };

    group = mkOption {
      default = "traefik";
      type = str;
      example = "docker";
      description = ''
        Group under which traefik runs.
        For the docker backend this needs to be set to `docker` instead.

        ::: {.note}
        If left as the default value this group will automatically be created
        on system activation, otherwise you are responsible for
        ensuring the group exists before the traefik service starts.
        :::
      '';
    };

    package = mkPackageOption pkgs "traefik" {};

    environmentFiles = mkOption {
      default = [];
      type = listOf path;
      example = ["/run/secrets/traefik.env"];
      description = ''
        Files to load as environment file. Environment variables from this file
        will be substituted into the static configuration file using envsubst.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.dynamic.file != null -> cfg.dynamic.dir == null;
        message = "The filename and directory options are mutually exclusive. It is recommended to use directory.";
      }
      {
        assertion = cfg.extraFiles != null -> cfg.dynamic.dir != null;
        message = "extraFiles requires the dynamic file provider to be set to directory";
      }
    ];
    systemd.services.traefik = {
      description = "Traefik web server";
      wants = ["network-online.target"];
      after = ["network-online.target"];
      wantedBy = ["multi-user.target"];
      startLimitIntervalSec = 86400;
      startLimitBurst = 5;
      serviceConfig = {
        EnvironmentFile = cfg.environmentFiles;
        ExecStartPre =
          optional (cfg.environmentFiles != [])
          (pkgs.writeShellScript "pre-start" ''
            umask 077
            ${getExe pkgs.envsubst} -i "${staticFile}" > "${finalStaticFile}"
          '');
        ExecStart = "${getExe cfg.package} --configfile=${finalStaticFile}"; # ${mkIf cfg.providers ...}
        Type = "simple";
        User = cfg.user;
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
        ReadWritePaths = [cfg.dataDir];
        RuntimeDirectory = "traefik";
      };
    };

    systemd.tmpfiles = {
      rules =
        [
        ]
        ++ optional (cfg.user == "traefik") "d '${cfg.dataDir}' 0700 ${cfg.user} ${cfg.group} - -"
        ++ optionals (cfg.dynamic.dir != null) (mapAttrsToList (key: value: "L+ '${cfg.dynamic.dir}/${key}' '${writeText key (toJSON value.settings)}' 0444 - - - -") cfg.extraFiles);
    };
    users.users = optionalAttrs (cfg.user == "traefik") {
      traefik = {
        group = cfg.group;
        isSystemUser = true;
        home = cfg.dataDir; #?
      };
    };
    users.groups = optionalAttrs (cfg.group == "traefik") {
      traefik = {};
    };
  };
}
