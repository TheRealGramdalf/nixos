{ config, lib, pkgs, ... }: {
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };
  };

  ## SDDM ##
  # Todo: Override this so that x11 isn't needed for hyprland
  # Most of the bloat can probably be fixed with excludePackages
  services.xserver.enable = true;
  services.xserver.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    #theme = "${pkgs.catppuccin-sddm-corners}"; # This method is probably preferred, and may be modified in the future
    theme = "catppuccin-sddm-corners";
  };
  environment.systemPackages = with pkgs; [
    # Catpuccin SDDM theme
    catppuccin-sddm-corners
    libsForQt5.qt5.qtgraphicaleffects
    #libsForQt5.qt5.qtsvg # Not needed?

    # Add a terminal 
    kitty # So the default super + m keybind works
  ];
}