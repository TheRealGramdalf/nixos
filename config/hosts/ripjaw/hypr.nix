{ config, lib, pkgs, ... }: {
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };
    waybar.enable = true;
  };

  ## SDDM ##
  services.xserver.enable = true; # Todo: Override this so that x11 isn't needed for hyprland
  services.xserver.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    #theme = "${pkgs.catppuccin-sddm-corners}"; # This method is probably preferred, and may be modified in the future
    theme = "catppuccin-sddm-corners";
  };
  environment.systemPackages = with pkgs; [
    catppuccin-sddm-corners
    libsForQt5.qt5.qtgraphicaleffects
    #libsForQt5.qt5.qtsvg
  ];
}