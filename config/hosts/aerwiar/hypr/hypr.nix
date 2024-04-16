{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.hyprland.enable = true;
  # Add a terminal
  # So the default super + m keybind works
  environment.systemPackages = [pkgs.kitty];
  hardware = {
    brillo.enable = true;
    bluetooth.enable = true;
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

  # Enable networkmanager
  networking.networkmanager.enable = true;
  imports = [
    ./sddm.nix
  ];
}
