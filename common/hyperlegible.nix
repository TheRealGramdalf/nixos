{pkgs, ...}: {
  fonts = {
    packages = [
      pkgs.atkinson-hyperlegible-next
      pkgs.atkinson-hyperlegible-mono
    ];
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = ["Atkinson Hyperlegible Next"];
        monospace = ["Atkinson Hyperlegible Mono"];
      };
    };
  };
}
