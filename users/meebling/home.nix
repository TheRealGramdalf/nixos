{pkgs, ...}: {
  imports = [
    ./firefox.nix
    ./kde-common.nix
  ];

  home = {
    sessionVariables = {
      EDITOR = "nvim";
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
      #calibre
      drawio
      # Utilities
      inkscape
      gnome-solanum # Pomodoro timer
      evince # Document viewer
      gcolor3 # Color picker
      clapper # Video viewer
      eog # Photo viewer
      dialect # Translate app
      drawing
      nautilus
    ];
  };
  programs = {
    bash.enable = true;
  };
}
