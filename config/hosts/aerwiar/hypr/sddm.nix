{ config, lib, pkgs, ... }: {
  # Awaiting PR coming to nixos-unstable
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