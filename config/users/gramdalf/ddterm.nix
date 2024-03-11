{ config, pkgs, lib, ... }: {
  home.packages = [ pkgs.gnomeExtensions.ddterm ];  
  dconf.settings = {
    "com/github/amezin/ddterm" = {
      # vi/vim requires escape to function
      hide-window-on-esc = false;
      scrollback-unlimited = true;
      show-scrollbar = false;
      notebook-border = false;
      ddterm-toggle-hotkey = [ "F1" ];
      panel-icon-type = "none";
      # Color profile. To migrate to a gnome-terminal profile, see: 
      #  https://mynixos.com/home-manager/options/programs.gnome-terminal.profile.%3Cname%3E
      # Use (FG/BG) colors specified below, not system defaults
      use-theme-colors = false;
      foreground-color = "rgb(230,230,230)"; # Text color
      background-color = "rgb(31,34,41)"; # Backdrop color
      background-opacity = 0.9;
      palette = [
        "rgb(23,20,33)" "rgb(192,28,40)" "rgb(94,189,171)" "rgb(162,115,76)" "rgb(54,123,240)" "rgb(163,71,186)" "rgb(42,161,179)" "rgb(208,207,204)"
        "rgb(94,92,100)" "rgb(246,97,81)" "rgb(51,218,122)" "rgb(233,173,12)" "rgb(42,123,222)" "rgb(192,97,203)" "rgb(51,199,222)" "rgb(255,255,255)"
      ];
      # Default palette: ['rgb(23,20,33)', 'rgb(192,28,40)', 'rgb(38,162,105)', 'rgb(162,115,76)', 'rgb(18,72,139)', 'rgb(163,71,186)', 'rgb(42,161,179)', 'rgb(208,207,204)', 'rgb(94,92,100)', 'rgb(246,97,81)', 'rgb(51,218,122)', 'rgb(233,173,12)', 'rgb(42,123,222)', 'rgb(192,97,203)', 'rgb(51,199,222)', 'rgb(255,255,255)']
    };
    # Extensions
    "org/gnome/shell".enabled-extensions = [ "ddterm@amezin.github.com" ];
  };
}
