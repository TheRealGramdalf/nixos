{pkgs, config, lib, ...}: {
  imports = [
    ./hypr/hypr.nix
    ./firefox.nix
  ];

  tomeutils.adhde = {
    enable = true;
  };

  home = {
    username = lib.mkForce "nonexistinguser";
    homeDirectory = lib.mkForce "/home/${config.home.username}";
    sessionVariables = {
      EDITOR = "nvim";
    };
    packages = with pkgs; [
      drawing
      gnome.nautilus
      # Word Processing
      libreoffice
      onlyoffice-bin # For improved compatibility over libreoffice
      vscodium
      obsidian
      evince # Document viewer
      clapper # Video viewer
      gnome.eog # Photo viewer
      vlc
    ];
  };
}
