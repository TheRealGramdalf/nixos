{pkgs, ...}: {
  imports = [
    ./firefox.nix
  ];

  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };
    packages = with pkgs; [
      drawing
      nautilus
      # Word Processing
      libreoffice
      onlyoffice-desktopeditors # For improved compatibility over libreoffice
      vscodium
      obsidian
      evince # Document viewer
      clapper # Video viewer
      eog # Photo viewer
      vlc
    ];
  };
}
