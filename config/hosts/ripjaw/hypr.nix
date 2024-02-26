{ config, lib, pkgs, ... }: {
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };
    swaylock = {
      enable = true;
      #settings = {
      #  color = "808080";
      #  font-size = 24;
      #  indicator-idle-visible = false;
      #  indicator-radius = 100;
      #  line-color = "ffffff";
      #  show-failed-attempts = true;
      #};
    };
    waybar.enable = true;
  };
  security.pam.services.swaylock = {};
}