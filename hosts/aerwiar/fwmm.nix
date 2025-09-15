{pkgs, lib, config, ...}: let
  fwmm = pkgs.python312Packages.callPackage {} ./pkg-fwmm.nix;
in {
  environment.systemPackages = [fwmm]
  #systemd.services."fwmm" = {
  #  path = lib.makeBinPath [
  #    pkgs.python312
  #    pkgs.python312Packages.pyserial
  #    pkgs.python312Packages.numpy
  #    pkgs.python312Packages.aiohttp
  #    pkgs.python312Packages.python-crontab
  #    # Missing filedialpy
  #  ];
  #};
}