{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./home.nix
  ];
  home = {
    stateVersion = "24.05";
  };
}
