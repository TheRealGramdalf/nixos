{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkOption
    mkEnableOption
    mkPackageOption
    mkIf
    forEach
    nameValuePair
    listToAttrs
    concatMapStringsSep
    types
    ;

  xmlValue = (pkgs.formats.xml {}).type;

  #TODO Make this an option either at the top level or under `settings`
  stateDir = "/var/ossec";
  cfg = config.services.wazuh.agent;
  agentAuthPassword = config.services.wazuh.agent.agentAuthPassword;

  daemons = [
    "wazuh-modulesd"
    "wazuh-logcollector"
    "wazuh-syscheckd"
    "wazuh-agentd"
    "wazuh-execd"
  ];

  mkService = d: {
    description = "${d}";
    wants = ["wazuh-agent-auth.service"];

    partOf = ["wazuh.target"];
    path =
      cfg.path
      ++ [
        "/run/current-system/sw/bin"
        "/run/wrappers/bin"
      ];
    environment = {
      WAZUH_HOME = stateDir;
    };

    serviceConfig = {
      Type = "exec";
      User = cfg.user;
      Group = cfg.group;
      WorkingDirectory = "${stateDir}/";
      CapabilityBoundingSet = ["CAP_SETGID"];

      ExecStart =
        if (d != "wazuh-modulesd")
        then "/run/wrappers/bin/${d} -f -c ${stateDir}/etc/ossec.conf"
        else "/run/wrappers/bin/${d} -f";
    };
  };
in {
  options = {
    services.wazuh.agent = {
      enable = mkEnableOption "Wazuh agent";
      package = mkPackageOption pkgs "wazuh-agent" {};

      user = mkOption {
        type = types.str;
        description = ''
          User to run the wazuh daemons as. Note that this option is read-only due to limitations in the module
        '';
        default = "wazuh";
      };
      group = mkOption {
        type = types.str;
        description = ''
          Group to run the wazuh daemons under. Note that this option is read-only due to limitations in the module
        '';
        default = "wazuh";
      };
      config = mkOption {
        type = types.path;
        description = ''
          Final configuration file used by wazuh
        '';
        default = (pkgs.formats.xml {}).generate "ossec.conf" {ossec_config = cfg.settings;};
      };

      #TODO determine which options are necessary for a default installation, which should have typing/be accessible always (e.g. port options)
      #TODO Determine if settings included as options here are only a selection or if they can be generated systematically from the Wazuh documentation

      # Documentation for these options can be found here: https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/index.html
      settings = mkOption {
        default = {};
        type = types.submodule {
          freeformType = types.attrsOf xmlValue;

          options = {
            client = {
              server = {
                address = mkOption {
                  type = types.nullOr types.nonEmptyStr;
                  description = ''
                    Specifies the IP address or the hostname of the Wazuh manager.
                  '';
                  example = "192.168.1.2";
                  default = null;
                };
                port = mkOption {
                  type = types.port;
                  description = ''
                    Specifies the port to send events to the manager. This must match the associated listening port configured on the Wazuh manager.
                  '';
                  default = 1514;
                };
              };
              enrollment = {
                manager_address = mkOption {
                  type = types.nullOr types.nonEmptyStr;
                  description = ''
                    Hostname or IP address of the manager where the agent will be enrolled. If no value is set, the agent will try enrolling to the same manager that was specified for connection.
                  '';
                  example = "192.168.1.2";
                  default = null;
                };
                port = mkOption {
                  type = types.port;
                  description = ''
                    Specifies the port on the manager to send enrollment request. This must match the associated listening port configured on the Wazuh manager.
                  '';
                  default = 1515;
                };
              };
            };
          };
        };
        description = ''
          Wazuh-agent configuration written in Nix. This will be serialized to XML and passed as `ossec.conf`

          Note that the root `ossec_config` tag is added automatically here
        '';
      };

      extraPackages = mkOption {
        type = types.listOf types.package;
        default = with pkgs; [
          util-linux
          coreutils-full
          nettools
          ps
        ];
        defaultText = ''
          with pkgs; [
            util-linux
            coreutils-full
            nettools
            ps
          ];
        '';
        example = lib.literalExpression "[ pkgs.util-linux pkgs.coreutils_full pkgs.nettools ]";
        description = "List of packages to put in wazuh-agent's path.";
      };

      agentAuthPassword = mkOption {
        type = types.nullOr types.nonEmptyStr;
        default = null;
        description = ''
          Password for the auth service
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      #TODO Determine if the agent should use a separate user than the other microservices
      description = "Wazuh agent user";
      home = stateDir;
      #TODO This should be set as `SupplementaryGroups` in the systemd service config if only specific daemons need the capabilities
      extraGroups = [
        "systemd-journal"
        "systemd-network"
      ]; # To read journal entries
    };

    users.groups.${cfg.group} = {};

    systemd.tmpfiles.rules = [
      "d ${stateDir}/tmp 0750 ${cfg.user} ${cfg.group} 1d"
    ];

    systemd.targets.multi-user.wants = ["wazuh.target"];
    systemd.targets.wazuh.wants = forEach daemons (d: "${d}.service");

    systemd.services =
      listToAttrs (map (daemon: nameValuePair daemon (mkService daemon)) daemons)
      // {
        wazuh-agent-auth = {
          description = "Sets up wazuh agent auth";
          after = [
            "setup-pre-wazuh.service"
            "network.target"
            "network-online.target"
          ];
          wants = [
            "setup-pre-wazuh.service"
            "network-online.target"
          ];
          before = map (d: "${d}.service") daemons;
          environment = {
            WAZUH_HOME = stateDir;
          };

          unitConfig = {
            ConditionPathExists = "!${stateDir}/.agent-registered";
          };

          serviceConfig = let
            ip =
              if cfg.registration.host != null
              then cfg.registration.host
              else cfg.manager.host;
            port =
              if cfg.registration.host != null
              then cfg.registration.port
              else cfg.manager.port;
          in {
            Type = "oneshot";
            User = cfg.user;
            Group = cfg.group;
            ExecStart = ''
              ${cfg.package}/bin/agent-auth -m ${ip} -p ${toString port} && touch ${stateDir}/.agent-registered
            '';
          };
        };

        setup-pre-wazuh = {
          description = "Sets up wazuh's directory structure";
          wantedBy = ["wazuh-agent-auth.service"];
          before = ["wazuh-agent-auth.service"];
          serviceConfig = {
            Type = "oneshot";
            User = cfg.user;
            Group = cfg.group;
            #TODO is lib.getExe necessary?
            ExecStart = lib.getExe pkgs.writeShellApplication {
              name = "wazuh-prestart";
              text = ''
                ${
                  concatMapStringsSep "\n"
                  (
                    dir: "[ -d ${stateDir}/${dir} ] || cp -Rv --no-preserve=ownership ${cfg.package}/${dir} ${stateDir}/${dir}"
                  )
                  [
                    "active-response"
                    "agentless"
                    "bin"
                    "etc"
                    "lib"
                    "logs"
                    "queue"
                    "tmp"
                    "var"
                    "wodles"
                  ]
                }

                chown -R ${cfg.user}:${cfg.group} ${stateDir}

                find ${stateDir} -type d -exec chmod 770 {} \;
                find ${stateDir} -type f -exec chmod 750 {} \;

                # Generate and link ossec.config
                ln -sf ${cfg.config} ${stateDir}/etc/ossec.conf

                ${lib.optionalString (!(isNull agentAuthPassword)) "echo ${agentAuthPassword} >> ${stateDir}/etc/authd.pass"}

              '';
            };
          };
        };
      };

    security.wrappers = listToAttrs (
      forEach daemons (
        d:
          nameValuePair d {
            setgid = true;
            setuid = true;
            owner = cfg.user;
            group = cfg.group;
            source = "${cfg.package}/bin/${d}";
          }
      )
    );
  };
}
