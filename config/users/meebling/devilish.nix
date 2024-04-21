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
    ./steam.nix
  ];
  home = {
    stateVersion = "24.05";
  };
}
