{ config, lib, pkgs, ... }: {
  programs.hyprland.enable = true;
  # Add a terminal 
  # So the default super + m keybind works
  environment.systemPackages = [ pkgs.kitty ];

  ## SDDM ##
  # Todo: Override this so that x11 isn't needed for hyprland
  # Most of the bloat can probably be fixed with excludePackages
  services.xserver.enable = true;
  services.xserver.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    #theme = "${pkgs.catppuccin-sddm-corners}/share/sddm/themes/catppuccin-sddm-corners/Main.qml"; # This method is probably preferred
    #theme = "catppuccin-sddm-corners";
    theme = "${pkgs.catppuccin-sddm-corners}";
    extraPackages = [
      pkgs.libsForQt5.qt5.qtgraphicaleffects
      #pkgs.catppuccin-sddm-corners # Might not work
      #libsForQt5.qt5.qtsvg # Not needed?
    ];
  };

}