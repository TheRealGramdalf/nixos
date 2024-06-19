{pkgs, ...}: {
  imports = [
    ./hypr/hypr.nix
    ./firefox.nix
  ];

  tomeutils.adhde = {
    enable = true;
  };

  home = {
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
