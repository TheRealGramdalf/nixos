{pkgs, ...}: {
  fonts = {
    packages = [
      pkgs.overpass
      pkgs.nerd-fonts.symbols-only
    ];
    enableDefaultPackages = false;
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Overpass"];
        sansSerif = ["Overpass"];
        monospace = ["Overpass Mono"];
      };
      hinting.enable = true;
      antialias = true;
    };
  };
}
