{pkgs, ...}: {
  tomeutils.vapor = {
    enable = true;
    extraPackages = [pkgs.gamescope];
  };
}
