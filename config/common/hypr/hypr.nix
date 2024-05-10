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

  networking.dhcpcd.enable = false;
  # Enable iwd (https://www.reddit.com/r/archlinux/comments/cs0zuh/first_time_i_heard_about_iwd_why_isnt_it_already/)
  networking.wireless.iwd = {
    enable = true;
    settings = {
      General.EnableNetworkConfiguration = (assert lib.asserts.assertMsg (config.networking.dhcpcd.enable == false) "You only need one DHCP daemon"; true);
      Network = {
        NameResolvingService = "resolvconf";
        #RoutePriorityOffset = 300;
      };
    };
  };
  # Create the `network` group as expected by iwd
  users.groups."network".gid = null;
  imports = [
    ./sddm.nix
  ];
}
