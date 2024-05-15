{pkgs, lib, config, ...}: {
  programs.hyprland.enable = true;
  # Add a terminal
  # So the default super + Q keybind works
  environment.systemPackages = [pkgs.kitty];
  hardware = {
    brillo.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
  };

  services = {
    udisks2.enable = true;
  };
  # Use wayland pls uwu
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
  };

  systemd = {
  user.services."polkit-agent" = {
    description = "polkit-kde-agent for Hyprland";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit-kde-agent}/libexec/polkit-kde-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  networking.dhcpcd.enable = false;
  networking.useDHCP = false;
  systemd.network.enable = true;
  networking.useNetworkd = true;
  # Enable iwd (https://www.reddit.com/r/archlinux/comments/cs0zuh/first_time_i_heard_about_iwd_why_isnt_it_already/)
  networking.wireless.iwd = {
    enable = true;
    settings = {
      General.EnableNetworkConfiguration = (assert lib.asserts.assertMsg (config.networking.dhcpcd.enable == false) "You only need one DHCP daemon"; true);
      Network = {
        NameResolvingService = "resolvconf";
        RoutePriorityOffset = 300;
      };
    };
  };
  # Create the `netdev` group as expected by iwd
  users.groups."netdev" = {};
  # Adding `https://wiki.archlinux.org/title/Iwd#Allow_any_user_to_read_status_information` may fix `iwd` not launching

  systemd.services."systemd-networkd-wait-online".enable = lib.mkForce false;
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
  imports = [
    ./sddm.nix
  ];
}
