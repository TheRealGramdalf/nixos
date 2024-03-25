{ config, lib, pkgs, ... }: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };
}