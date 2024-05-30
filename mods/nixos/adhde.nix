{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) types;
  inherit (lib) mkEnableOption mkMerge mkOption mkIf optionals;
  cfg = config.tomeutils.adhde;
in {
  options.tomeutils.adhde = {
    enable = mkEnableOption "ADHDE, a set of usable Hyprland defaults for the scatterbrained" // {default = false;};

    udiskie = {
      enable = mkEnableOption "a user systemd service for udiskie, the userspace removable media mounting GUI" // {default = true;};
      args = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = ["--tray" "--no-automount"];
        description = "Verbatim args passed to `udiskie`";
      };
    };
    qtwayland.enable = mkEnableOption "support for QT applications" // {default = cfg.enable;};
    pipewire.enable = mkEnableOption "pipewire with compatibility settings" // {default = cfg.enable;};

    polkit-agent = {
      enable = mkEnableOption "a user systemd service for kde-polkit-agent, the priviledge escalation GUI" // {default = config.security.polkit.enable;};
      args = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = [];
        description = "Verbatim args passed to `polkit-kde-agent`";
      };
    };
    sddm.enable = mkEnableOption "SDDM, a wayland-friendly display manager" // {default = cfg.enable;};
    nextGenNet.enable = mkEnableOption "NextGenNet, a modern network configuration backed by IWD, systemd-networkd and Avahi" // {default = cfg.enable;};
    # This needs tweaking to allow for other desktop environments
    useWayland = mkOption {
      type = types.bool;
      default = cfg.enable;
      description = "Whether to hint xwayland apps that they should use wayland natively";
    };
  };

  ##### Implementation
  config = mkIf cfg.enable (mkMerge [
    {programs.hyprland.enable = true;}

    (mkIf cfg.qtwayland.enable {
      environment.systemPackages = with pkgs; [
        libsForQt5.qt5.qtwayland
        kdePackages.qtwayland # qt6
      ];
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
        SDL_VIDEODRIVER = "wayland";
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

    (mkIf cfg.nextGenNet.enable {
      # These need to be looked through for conflicts
      networking.dhcpcd.enable = false;
      networking.useDHCP = false;
      systemd.network.enable = true;
      networking.useNetworkd = true;
      # Enable iwd (https://www.reddit.com/r/archlinux/comments/cs0zuh/first_time_i_heard_about_iwd_why_isnt_it_already/)
      networking.wireless.iwd = {
        enable = true;
        settings = {
          General.EnableNetworkConfiguration = assert lib.asserts.assertMsg (config.networking.dhcpcd.enable == false) "You only need one DHCP daemon"; true;
          Network = {
            NameResolvingService = "resolvconf";
            RoutePriorityOffset = 300;
          };
        };
      };
      # Create the `netdev` group as expected by iwd. Why doesn't this happen by default? The bald frog knows.
      users.groups."netdev" = {};
      # Adding `https://wiki.archlinux.org/title/Iwd#Allow_any_user_to_read_status_information` may fix `iwd` not launching

      # this tends to slow down rebuilds, and in general isn't useful for most GUI machines
      systemd.services."systemd-networkd-wait-online".enable = lib.mkForce false;
      # This allows you to plug in random ethernet cables and obtain an address via DHCP
      systemd.network.networks."69-ether" = {
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
        };
      };
      # Avahi is what powers mDNS, i.e. ${hostname}.local
      services.avahi = {
        enable = true;
        ipv6 = true;
        nssmdns4 = true;
        nssmdns6 = true;
        openFirewall = true;
      };
      # NTP client
      services.chrony.enable = true;
    })
  ]);
}
