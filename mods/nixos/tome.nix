{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.types) listOf str nullOr;
  inherit (lib) mkEnableOption mkMerge mkOption mkIf;
  cfg = config.tome;
in {
  options.tome = {
    utils.enable = mkEnableOption "the addition of some generic troubleshooting/QoL packages to the system" // {default = false;};
    entworking = {
      enable = mkEnableOption "entworking, a modern network configuration backed by iwd and systemd" // {default = false;};
      domains = mkOption {
        type = nullOr (listOf str);
        default = ["local" "lan"];
        description = "Domains to attempt resolution via mDNS. Usually .local, .lan, or .home.arpa";
      };
      vpn =
        mkEnableOption "installation & configuration of the netbird client"
        // {
          default =
            if cfg.entworking.profile == "server"
            then true
            else false;
        };
      profile = mkOption {
        type = oneOf ["gui-wired" "gui-wireless" "server"];
        description = "Which profile to use. This primarily sets defaults for other options";
        default = "gui-wired";
      };
      mdns = mkOption {
        type = oneOf ["avahi" "resolve"];
        description = "Which mDNS backend to use for advertisement. systemd-resolved is used unconditionally for resolution.";
        default =
          if cfg.entworking.profile == "server"
          then "avahi"
          else "resolve";
      };
    };
    ntfs.udev =
      mkEnableOption ''
        ntfs3 UDEV rules to use ntfs3 for filesystem type `ntfs`, fixing issues such as "unknown filesystem type 'ntfs'".
        Note that "this method is not recommended and can confuse some 3rd party tools."
      ''
      // {default = false;};
  };

  ##### Implementation
  config = mkMerge [
    (mkIf cfg.thing.enable {
      stuff = true;
    })

    (mkIf cfg.utils {
      environment.systemPackages = with pkgs; [
        git
        neovim
        btop
        tmux
        sysz
        smartmontools
        fastfetch
      ];
    })

    (mkIf cfg.ntfs.udev {
      services.udev.extraRules = ''
        SUBSYSTEM=="block", ENV{ID_FS_TYPE}=="ntfs", ENV{ID_FS_TYPE}="ntfs3"
      '';
    })

    (mkIf cfg.entworking.vpn {
      # This enables the client, not the management server.
      # Registering is currently handled imperatively via setup keys
      services.netbird.enable = true;
      # Add some env vars so that netbird points to the right server
      environment.sessionVariables = {
        NB_ADMIN_URL = "https://vpn.aer.dedyn.io";
        NB_MANAGEMENT_URL = "https://vpn.aer.dedyn.io";
      };
    })

    (mkIf cfg.entworking.enable {
      assertions = [
        {
          assertion = (!config.networking.dhcpcd.enable) && (!config.networking.useDHCP);
          message = "`systemd-networkd` and `iwd` have integrated DHCP clients. Enabling another will cause conflicts/loss of networking";
        }
      ];

      # this tends to slow down rebuilds, and in general isn't useful for most GUI machines
      systemd.network.wait-online.enable = lib.mkDefault false;

      networking = {
        # Disable other DHCP clients
        dhcpcd.enable = false;
        useDHCP = false;
        # Use `systemd-networkd` instead of scripted networking
        # (as far as I can tell) systemd-networkd is a fully fledged daemon that can handle many of the same configuration files,
        # scripted networking is essentially a bunch of bash scripts which achieve the same function via `ifconfig` or `ip`
        useNetworkd = true;
        firewall.allowedUDPPorts = [
          5353
        ];
      };

      # Wireless (Wifi)
      # Enable iwd (https://www.reddit.com/r/archlinux/comments/cs0zuh/first_time_i_heard_about_iwd_why_isnt_it_already/)
      # Adding `https://wiki.archlinux.org/title/Iwd#Allow_any_user_to_read_status_information` may fix `iwgtk` not launching
      networking.wireless.iwd = {
        enable = true;
        # See `man iwd.network` and `man iwd.config` for documentation
        settings = {
          # Use IWD's internal mechanisms for DHCP
          General.EnableNetworkConfiguration = true;
          Network = {
            # Integrate with systemd for e.g. mDNS
            NameResolvingService = "systemd";
            # Set the priority high to prefer ethernet when available
            RoutePriorityOffset = 300;
          };
        };
      };
      # Create the `netdev` group as expected by iwd. Why doesn't this happen by default? The bald frog knows.
      # Adding a user to this group allows them to manage wifi connections
      users.groups."netdev" = {};

      # Wired (Ethernet)
      # This allows you to plug in random ethernet cables and obtain an address via DHCP
      systemd.network = {
        enable = true;
        networks."69-ether" = {
          # Match all non-virtual (veth) ethernet connections
          matchConfig = {
            Type = "ether";
            Kind = "!*";
          };
          # Prefer a wired connection over wireless
          dhcpV4Config.RouteMetric = 100;
          # Further prefer ipv6
          dhcpV6Config.RouteMetric = 200;
          networkConfig = {
            DHCP = true;
            IPv6PrivacyExtensions = true;
            # Enable mDNS responding and resolving on this match
            MulticastDNS = true;
          };
          # Enable mDNS on this match
          linkConfig.Multicast = true;
        };
      };

      # mDNS
      # multicast DNS is what powers ${hostname}.local
      # systemd-resolved can act as a responder and resolver, or just a resolver
      # avahi can act as any combination of responder, resolver or none.
      # the primary advantage of avahi is it's ability to publish records other than hostnames, such as SMB shares

      # Enable full mDNS support. `iwd` will use this as the default if systemd integration is enabled.
      services.resolved.settings."Resolve" = {
        LLMNR = "false";
        MulticastDNS = true;
      };
      # Disable avahi due to it's low level of integration with systemd-networkd
      # Avahi may still be desirable on static devices like servers, where `allowinterfaces` can be tuned properly
      services.avahi.enable = false;

      # NTP client
      services.chrony.enable = true;
    })
  ];
}
