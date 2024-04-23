{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./home.nix
    ./steam.nix
  ];
  home = {
    stateVersion = "24.05";
  };
}
