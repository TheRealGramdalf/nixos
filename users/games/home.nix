{pkgs, ...}: {
  imports = [
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
      nautilus
      # Word Processing
      libreoffice
      onlyoffice-bin # For improved compatibility over libreoffice
      vscodium
      obsidian
      evince # Document viewer
      clapper # Video viewer
      eog # Photo viewer
      vlc
    ];
  };
}
