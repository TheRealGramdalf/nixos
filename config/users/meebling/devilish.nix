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
    username = "meeblingthedevilish";
    homeDirectory = "/home/meeblingthedevilish";
    stateVersion = "24.05";
  };
}