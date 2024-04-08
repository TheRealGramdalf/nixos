{ config, pkgs, lib, ... }:

{
  imports = [
    ./zsh.nix
    ./waybar.nix
    ./anyrun.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];
  home = {
    username = "gramdalf";
    homeDirectory = "/home/gramdalf";
    stateVersion = "24.05";
    # Custom txt files (Source: https://github.com/nix-community/home-manager/issues/1493)
    file = {
    ".icons/SpaceKCursors".source = ./assets/SpaceKCursors;
    };
    sessionVariables = {
      EDITOR = "nvim";
      MOZ_ENABLE_WAYLAND = "1";
    };
    packages = with pkgs; [
      #### GUI ####
      remmina
      # Communication
      zoom-us
      # Word Processing
      libreoffice
      onlyoffice-bin # For improved compatibility over libreoffice
      vscodium
      obsidian
      # Services
      bitwarden
      # File editors
      audacity
      # pitivi # Video editor
      blender
      gimp
      calibre
      drawio
      # Utilities
      btop
      inkscape
      filezilla
      motrix # Download manager
      gnome-obfuscate
      baobab # Disk usage analyzer
      gnome-solanum # Pomodoro timer
      eartag # File tag editor
      evince # Document viewer
      gcolor3 # Color picker
      clapper # Video viewer
      gnome.eog # Photo viewer
      gnome.gnome-power-manager # Battery stats
      dialect # Translate app
      drawing
      gnome.nautilus
      gnome.simple-scan
      #### CLI ####
      unzip
      plocate
      # Asus ROG drivers
      #asusctl
      # DGPU utils
      #supergfxctl
    ];
  };  
  programs = {
    home-manager.enable = true;
    bash.enable = true;
    
/*    firefox = {
      enable = true;
      package = pkgs.floorp;
      profiles.gramdalf = {
         isDefault = true;
      }
    };
*/
  };
}
