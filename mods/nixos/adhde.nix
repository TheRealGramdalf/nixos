{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.types) listOf str nullOr bool;
  inherit (lib) mkEnableOption mkMerge mkOption mkIf;
  cfg = config.tomeutils.adhde;
in {
  options.tomeutils.adhde = {
    enable = mkEnableOption "ADHDE, a set of usable Hyprland defaults for the scatterbrained" // {default = false;};

    udiskie = {
      enable = mkEnableOption "a user systemd service for udiskie, the userspace removable media mounting GUI" // {default = true;};
      args = mkOption {
        type = nullOr (listOf str);
        default = ["--tray" "--no-automount"];
        description = "Verbatim args passed to `udiskie`";
      };
    };
    qtwayland.enable = mkEnableOption "support for QT applications" // {default = cfg.enable;};
    pipewire.enable = mkEnableOption "pipewire with compatibility settings" // {default = cfg.enable;};

    polkit-agent = {
      enable = mkEnableOption "a user systemd service for kde-polkit-agent, the priviledge escalation GUI" // {default = config.security.polkit.enable;};
      args = mkOption {
        type = nullOr (listOf str);
        default = [];
        description = "Verbatim args passed to `polkit-kde-agent`";
      };
    };
    sddm.enable = mkEnableOption "SDDM, a wayland-friendly display manager" // {default = cfg.enable;};
    entworking.enable = mkEnableOption "entworking, a modern network configuration backed by IWD, systemd-networkd and Avahi" // {default = cfg.enable;};
    # This needs tweaking to allow for other desktop environments
    useWayland = mkOption {
      type = bool;
      default = cfg.enable;
      description = "Whether to hint xwayland apps that they should use wayland natively";
    };
  };

  ##### Implementation
  config = mkIf cfg.enable (mkMerge [
    {
      programs.hyprland.enable = true;
      # Enable support for hyprlock in userspace
      security.pam.services.hyprlock = {};
    }

    (mkIf cfg.qtwayland.enable {
      environment.systemPackages = with pkgs; [
        libsForQt5.qt5.qtwayland
        kdePackages.qtwayland # qt6
      ];
      qt = {
        enable = true;
        platformTheme = "gnome";
        style = "adwaita-dark";
      };
    })

    (mkIf cfg.pipewire.enable {
      services.pipewire = {
        enable = true;
        audio.enable = true;
        alsa.enable = true;
        pulse.enable = true;
        wireplumber.enable = true;
      };
    })

    (mkIf cfg.useWayland {
      # Use wayland pls uwu
      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        GDK_BACKEND = "wayland,x11";
        QT_QPA_PLATFORM = "wayland;xcb";
        #SDL_VIDEODRIVER = "wayland";
        CLUTTER_BACKEND = "wayland";
        MOZ_ENABLE_WAYLAND = "1";
      };
    })

    (mkIf cfg.sddm.enable {
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        theme = "${pkgs.catppuccin-sddm-corners}/share/sddm/themes/catppuccin-sddm-corners"; # Not including `Main.qml`, since SDDM does this automagically
        extraPackages = [
          pkgs.libsForQt5.qt5.qtgraphicaleffects
          pkgs.libsForQt5.qt5.qtsvg
        ];
      };
    })

    # These services should be started after `hyprland-session.target`, not `graphical-session` if possible
    (mkIf cfg.udiskie.enable {
      services.udisks2.enable = true;
      systemd.user.services."udiskie" = {
        description = "Userspace daemon for udisks2";
        wantedBy = ["graphical-session.target"];
        wants = ["graphical-session.target"];
        after = ["graphical-session.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${lib.getExe' pkgs.udiskie "udiskie"} ${builtins.concatStringsSep " " cfg.udiskie.args}";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    })

    (mkIf cfg.polkit-agent.enable {
      systemd.user.services."polkit-agent" = {
        description = "polkit-kde-agent for Hyprland";
        wantedBy = ["graphical-session.target"];
        wants = ["graphical-session.target"];
        after = ["graphical-session.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1 ${builtins.concatStringsSep " " cfg.polkit-agent.args}";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    })

    (mkIf cfg.entworking.enable {
      assertions = [
        {
          assertion = (!config.networking.dhcpcd.enable) && (!config.networking.useDHCP);
          message = "`systemd-networkd` and `iwd` have integrated DHCP clients. Enabling another will cause conflicts/loss of networking";
        }
        {
          assertion = !config.services.avahi.enable;
          message = "Avahi conflicts with `resolved`s (and by proxy `iwd`s) mDNS implementation. Disable one of them.";
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
      services.resolved = {
        llmnr = "false";
        extraConfig = ''
          [Resolve]
          MulticastDNS = true
        '';
      };
      # Disable avahi due to it's low level of integration with systemd-networkd
      # Avahi may still be desirable on static devices like servers, where `allowinterfaces` can be tuned properly
      services.avahi.enable = false;

      # NTP client
      services.chrony.enable = true;
    })
  ]);
}
