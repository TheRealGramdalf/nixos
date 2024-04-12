{ config, pkgs, lib, context, ... }: {
  home.pointerCursor = {
    size = 24;
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.catppuccin-cursors.mochaLavender;
    name = "Catppuccin-Mocha-Lavender-Cursors";
  };  
}