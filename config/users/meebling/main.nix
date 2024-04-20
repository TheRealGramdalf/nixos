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
    username = "meebling";
    homeDirectory = "/home/meeblingthedevilish";
    stateVersion = "24.05";
  };
}