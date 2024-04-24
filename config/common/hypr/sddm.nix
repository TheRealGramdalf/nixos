{
  pkgs,
  ...
}: {
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "${pkgs.catppuccin-sddm-corners}/share/sddm/themes/catppuccin-sddm-corners"; # Not including `Main.qml`, since SDDM does this automagically
    extraPackages = [
      pkgs.libsForQt5.qt5.qtgraphicaleffects
      pkgs.libsForQt5.qt5.qtsvg # Not needed?
    ];
  };
}
