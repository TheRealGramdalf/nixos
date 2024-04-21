{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hypr/hypr.nix
    ./firefox.nix
    ./home.nix
  ];
  home = {
    stateVersion = "24.05";
  };
}
