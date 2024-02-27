{ config, lib, pkgs, ... }: {
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };
    waybar.enable = true;
  };
  services.xserver.enable = true; # Todo: Override this so that x11 isn't needed for hyprland
  services.xserver.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "${pkgs.catppuccin-sddm-corners}";
  };
}