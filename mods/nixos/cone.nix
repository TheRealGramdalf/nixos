{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.types) nullOr str listOf path literalExpression attrsOf submodule bool;
  inherit (lib) optional optionals getExe mkIf optionalAttrs mkOption mkEnableOption mkPackageOption mapAttrsToList mkDefault mkRenamedOptionModule;
  inherit (builtins) toJSON;
  inherit (pkgs) writeText;
  cfg = config.services.cone;
  jsonValue = (pkgs.formats.json {}).type;

  staticFile =
    if cfg.static.file == null
    then writeText "static_config.json" (builtins.toJSON cfg.static.settings)
    else cfg.static.file;

  finalStaticFile =
    if !cfg.useEnvSubst
    then staticFile
    else "/run/traefik/config.json";
in {
  imports = [
    (mkRenamedOptionModule ["services" "cone" "staticConfigFile"] ["services" "cone" "static" "file"])
    (mkRenamedOptionModule ["services" "cone" "staticConfigOptions"] ["services" "cone" "static" "settings"])
    (mkRenamedOptionModule ["services" "cone" "dynamicConfigFile"] ["services" "cone" "dynamic" "file"])
    (mkRenamedOptionModule ["services" "cone" "dynamicConfigOptions"] ["services" "cone" "dynamic" "settings"])
  ];
  options.services.cone = {
    # TODO
    # - [] Rather than using `let`, set `cfg.dynamic.file` to writeText toJSON
    # - [] Add "virtualHosts" convenience feature?
    # - [] Fix defaultText, example (replace with `'' ''`), etc.
    # - [] If using virtualHost, make it top level (services.traefik.virthosts), and make it a convenience function. Make it assert conflictions with dynamic file
    # - [] Replace default text with clear logic examples
    # - [] Add descr. for options used by the module
    # - [] nixos Tests?
    # - [] Configuration test via https://github.com/traefik/traefik/issues/10804 (need to grab schema from traefik pkg, add schema output to traefik pkg)
    # - [] https://github.com/NixOS/nixpkgs/blob/6fd558c210c90f72c8116a0ea509f4280356d2bb/nixos/modules/services/web-servers/caddy/default.nix#L345C5-L345C63
    # CHANGELOG
    # - Removed usage of `with`, replacing it with `inherit` instead
    # - Do not always assume the systemd user must be created by NixOS
    # - Rename options to be more ergonomic and in line with the spirit of RFC 42
    # - (minimal downtime)
    # - Added `mkRenamedOptionModule`s where appropriate
    # - If created, the `traefik` users home directory is no longer created
    # - Increase UDP buffer sizes similar to caddy
    enable = mkEnableOption "Traefik web server";
    static = {
      file = mkOption {
        default = null;
        example = literalExpression "/path/to/static_config.toml";
        type = nullOr path;
        description = ''
          Path to traefik's static configuration to use.

          ::: {.note}
          Using this option has precedence over {option}`services.cone.static.settings`
          :::
        '';
      };
      settings = mkOption {
        description = ''
          Static configuration for Traefik, written in nix

          ::: {.note}
          This will be serialized to JSON (which is considered valid YAML) at build, and passed to Traefik as `--configfile`
          :::
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

          ::: {.note}
          Using this option has precedence over {option}`services.cone.dynamic.settings`
          :::
        '';
      };
      dir = mkOption {
        default = null;
        example = literalExpression "/etc/traefik/dynamic-config";
        type = nullOr path;
        description = ''
          Path to the directory traefik should watch.

          ::: {.warning}
          Files in this directory matching the glob _nixos-* (reserved for extraFiles) will be deleted as part of
          systemd-tmpfiles-resetup.service, _**regardless of their origin.**_
          :::
        '';
      };

      settings = mkOption {
        description = ''
          Dynamic configuration for Traefik, written in nix.

          ::: {.note}
          This will be serialized to JSON (which is considered valid YAML) at build, and passed as part of the static file
          :::
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
              http.routers."api" = {
                service = "api@internal";
                rule = "Host(`localhost`)";
              };
            };
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
        Extra dynamic configuration files to write. These are symlinked in `cfg.dynamic.dir` upon activation,
        allowing configuration to be upated without restarting the primary daemon.

        ::: {.note}
        Due to [a limitation in Traefik](https://github.com/traefik/traefik/issues/10890); any syntax error in a dynamic configuration will cause the entire file provider to be ignored.
        This may cause interuption in service, which may include access to the traefik dashboard, if enabled and configured to use [traefik-ception](https://doc.traefik.io/traefik/operations/dashboard/#secure-mode).
        :::
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
      description = ''
        Primary group under which traefik runs.
        For the docker backend, prefer {option}`services.cone.supplementaryGroups`

        ::: {.note}
        If left as the default value this group will automatically be created
        on system activation, otherwise you are responsible for
        ensuring the group exists before the traefik service starts.
        :::
      '';
    };

    supplementaryGroups = mkOption {
      default = [];
      type = listOf str;
      example = ["docker"];
      description = ''
        Additional groups under which traefik runs.
        This can be used to give additional permissions, such as required by the `docker` provider.

        ::: {.note}
        With the `docker` provider, traefik manages connection to containers via the docker socket,
        which requires membership of the `docker` group for write access
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
        ::: {.warn}
        The traefik static configuration methods (env, CLI, and file) are mutually exclusive.
        Rather than setting secret values with the traefik environment variable syntax,
        it is recommended to set arbitray environment variables, then reference them with `$VARNAME` in e.g.
        {option}`services.cone.static.settings`.
        :::
      '';
    };
    useEnvSubst = mkOption {
      # Should this be enabled by default if using env files, as it adds (?) start time and closure size
      default = cfg.environmentFiles != [];
      type = bool;
      example = true;
      description = ''
        Whether to use [`envSubst`]() in the ExecStartPre phase to augment the generated static config. See {option}`services.cone.environmentFiles`
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
      {
        assertion = cfg.group != "docker";
        message = "Setting the primary group to `docker` will cause files (such as those generated by extraFiles) to be owned by the group `docker`, which may be a security risk. Uses `supplementaryGroups` instead.";
      }
    ];

    # https://github.com/quic-go/quic-go/wiki/UDP-Buffer-Sizes
    boot.kernel.sysctl."net.core.rmem_max" = mkDefault 2500000;
    boot.kernel.sysctl."net.core.wmem_max" = mkDefault 2500000;

    services.cone.static.settings = mkIf (cfg.dynamic.dir != null || cfg.dynamic.file != null) {
      providers.file = {
        directory = mkIf (cfg.dynamic.dir != null) cfg.dynamic.dir;
        filename = mkIf (cfg.dynamic.file != null) cfg.dynamic.file;
        watch = mkDefault true;
      };
    };
    systemd.services.traefik = {
      description = "Traefik reverse proxy";
      wants = ["network-online.target"];
      after = ["network-online.target"];
      wantedBy = ["multi-user.target"];
      startLimitIntervalSec = 86400;
      startLimitBurst = 5;
      serviceConfig = {
        EnvironmentFile = cfg.environmentFiles;
        ExecStartPre =
          optional cfg.useEnvSubst
          (pkgs.writeShellScript "pre-start" ''
            umask 077
            ${getExe pkgs.envsubst} -i "${staticFile}" > "${finalStaticFile}"
          '');
        ExecStart = "${getExe cfg.package} --configfile=${finalStaticFile}";
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        SupplementaryGroups = mkIf (cfg.supplementaryGroups != []) cfg.supplementaryGroups;
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
        ReadOnlyPaths =
          optional (cfg.dynamic.dir != null) cfg.dynamic.dir;

        RuntimeDirectory = "traefik";
      };
    };

    systemd.tmpfiles = {
      rules =
        optional (cfg.user == "traefik") "d ${cfg.dataDir} 0700 ${cfg.user} ${cfg.group} - -"
        ++ optional (cfg.dynamic.dir != null) "d ${cfg.dynamic.dir} 0700 ${cfg.user} ${cfg.group} - -"
        # Clean all old tmpfiles in the dynamic directory
        ++ optional (cfg.dynamic.dir != null) "r ${cfg.dynamic.dir}/_nixos-* - - - - -"
        # Only files ending in (yml|yaml|toml) are accepted by traefik, even though JSON is valid yaml
        ++ optionals (cfg.dynamic.dir != null) (mapAttrsToList (key: value: "L+ ${cfg.dynamic.dir}/_nixos-${key}.yml 0444 - - - ${writeText key (toJSON value.settings)}") cfg.extraFiles);
    };
    users.users = optionalAttrs (cfg.user == "traefik") {
      traefik = {
        inherit (cfg) group;
        isSystemUser = true;
      };
    };
    users.groups = optionalAttrs (cfg.group == "traefik") {
      traefik = {};
    };
  };
}
