{
  config,
  lib,
  pkgs,
  ...
}: {
  # Use `nwg-look` to test out themes
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Mauve-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["mauve"];
        #tweaks = [ "rimless" "black" ];
        variant = "mocha";
      };
    };
  };
  # Symlinking the `~/.config/gtk-4.0/` folder is done by home-manager automatically
  # Enable dark mode for certain apps
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
  };
}
