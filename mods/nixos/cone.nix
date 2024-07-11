{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.types) nullOr str listOf path literalExpression attrsOf submodule;
  inherit (lib) optional optionals getExe mkIf optionalAttrs mkOption mkEnableOption mkPackageOption mapAttrsToList mkDefault;
  inherit (builtins) toJSON;
  inherit (pkgs) writeText;
  cfg = config.services.cone;
  jsonValue = (pkgs.formats.json {}).type;

  dynamicFile =
    if (cfg.dynamic.file == null && cfg.dynamic.dir == null)
    then writeText "dynamic_config.json" (builtins.toJSON cfg.dynamic.settings)
    else cfg.dynamic.file;

  staticFile =
    if cfg.static.file == null
    then writeText "static_config.json" (builtins.toJSON cfg.static.settings)
    else cfg.static.file;

  configNote = ''
    ::: {.note}
    Traefik config is serialized to JSON, which is considered valid YAML since 1.2
    :::
  '';
in {
  options.services.cone = {
    # TODO
    # - [x] inherit lib.types, remove `with`
    # - [x] Figure out dynamic folder logic/assertions
    # - [] Add "virtualHosts" convenience feature?
    # - [x] Remove `config` from static/dynamic
    # - [] Fix defaultText, example (replace with `'' ''`), etc.
    # - [?] Fix tmpfiles rules, readWritePaths
    # - [x] Follow caddy for user creation (don't assume it's always created)
    # - [] Use statix?
    # - [] If using virtualHost, make it top level (services.traefik.virthosts), and make it a convenience function. Make it assert conflictions with dynamic file
    # - [] Replace default text with clear logic examples
    # - [x] check rfc 42 https://github.com/NixOS/rfcs/blob/master/rfcs/0042-config-option.md
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
    # - [] Use `supplementaryGroups` for docker, since otherwise files managed by the `tmpfiles` rules are owned by group docker
    # - [] Assertion for extraFiles and traefik.enable
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
          entryPoints = {
            "web" = {
              address = ":80";
              http.redirections.entryPoint = {
                permanent = true;
                scheme = "https";
                to = "websecure";
              };
            };
            "websecure" = {
              address = ":443";
              asDefault = true;
            };
          };
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
        example = literalExpression "/etc/traefik/dynamic-config";
        type = nullOr path;
        description = ''
          Path to the directory traefik should watch.
          ::: {.warning}
          Files in this directory matching the glob _nixos-* will be deleted as part of
          systemd-tmpfiles-resetup.service, _**regardless of their origin.**_
          :::
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
          http.routers."api" = {
            service = "api@internal";
            rule = "Host(`192.168.122.217`)";
          };
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
        Files to load as environment file just before Traefik starts.
        This can be used to pass secrets such as [DNS challenge API tokens](https://doc.traefik.io/traefik/https/acme/#providers) or [EAB credentials](https://doc.traefik.io/traefik/reference/static-configuration/env/).
        ```
        DESEC_TOKEN=
        TRAEFIK_CERTIFICATESRESOLVERS_<NAME>_ACME_EAB_HMACENCODED=
        TRAEFIK_CERTIFICATESRESOLVERS_<NAME>_ACME_EAB_KID=
        ```
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

    services.cone.static.settings = mkIf (cfg.dynamic.dir != null || cfg.dynamic.file != null) {
      providers.file = {
        directory = mkIf (cfg.dynamic.dir != null) cfg.dynamic.dir;
        filename = mkIf (cfg.dynamic.file != null) cfg.dynamic.file;
        watch = mkDefault true;
      };
    };
    systemd.services.traefik = {
      description = "Traefik web server";
      wants = ["network-online.target"];
      after = ["network-online.target"];
      wantedBy = ["multi-user.target"];
      startLimitIntervalSec = 86400;
      startLimitBurst = 5;
      serviceConfig = {
        EnvironmentFile = cfg.environmentFiles;
        ExecStart = "${getExe cfg.package} --configfile=${staticFile}";
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
        ReadWritePaths = [
          cfg.dataDir
        ];
        ReadOnlyPaths = [
        ]
        ++ optional (cfg.dynamic.dir != null) cfg.dynamic.dir;

        RuntimeDirectory = "traefik";
      };
    };

    systemd.tmpfiles = {
      rules =
        [
        ]
        ++ optional (cfg.user == "traefik") "d ${cfg.dataDir} 0700 ${cfg.user} ${cfg.group} - -"
        ++ optional (cfg.dynamic.dir != null) "d ${cfg.dynamic.dir} 0700 ${cfg.user} ${cfg.group} - -"
        # Clean all old tmpfiles in the dynamic directory
        ++ optional (cfg.dynamic.dir != null) "r ${cfg.dynamic.dir}/_nixos-* - - - - -"
        # Only files ending in (yml|yaml|toml) are accepted by traefik, even though JSON is valid yaml
        ++ optionals (cfg.dynamic.dir != null) (mapAttrsToList (key: value: "L+ ${cfg.dynamic.dir}/_nixos-${key}.yml 0444 - - - ${writeText key (toJSON value.settings)}") cfg.extraFiles);
    };
    users.users = optionalAttrs (cfg.user == "traefik") {
      traefik = {
        group = cfg.group;
        isSystemUser = true;
      };
    };
    users.groups = optionalAttrs (cfg.group == "traefik") {
      traefik = {};
    };
  };
}
