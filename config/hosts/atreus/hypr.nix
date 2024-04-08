{ config, lib, pkgs, ... }: {
  programs.hyprland.enable = true;
  # Add a terminal 
  # So the default super + m keybind works
  environment.systemPackages = [ pkgs.kitty ];
  
  # Enable networkmanager
  networking.networkmanager.enable = true;


  ## SDDM ##
  # Todo: Override this so that x11 isn't needed for hyprland
  # Most of the bloat can probably be fixed with excludePackages
  services.xserver = {
    enable = true;
    excludePackages = with pkgs; [
      xterm
      x11_ssh_askpass
    ];
  };

  services.xserver.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "${pkgs.catppuccin-sddm-corners}/share/sddm/themes/catppuccin-sddm-corners"; # Not including `Main.qml`, since SDDM does this automagically
    extraPackages = [
      pkgs.libsForQt5.qt5.qtgraphicaleffects
      #libsForQt5.qt5.qtsvg # Not needed?
    ];
  };
}