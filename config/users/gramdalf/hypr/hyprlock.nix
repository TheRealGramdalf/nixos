{ config, pkgs, lib, ... }: {
  home.file.".config/hypr/hyprlock.conf".source = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "hyprlock";
    rev = "d5a6767000409334be8413f19bfd1cf5b6bb5cc6";
    #hash = "";
  } + "/hyprlock.conf"; 
}
