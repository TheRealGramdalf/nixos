{
  pkgs,
  lib,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: {
      inherit
        (prev.lixPackageSets.stable)
        nix-eval-jobs
        nix-fast-build
        colmena
        ;
    })
  ];

  nix.package = lib.mkForce pkgs.lixPackageSets.stable.lix;
}
