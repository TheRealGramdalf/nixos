{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  fwmm = pkgs.python313Packages.callPackage ./pkg-fwmm.nix {
    filedialpy = inputs.self.packages.x86_64-linux.filedialpy;
    python = pkgs.python313;
  };
in {
  environment.systemPackages = [fwmm];
  #systemd.services."fwmm" = {
  #};
}
