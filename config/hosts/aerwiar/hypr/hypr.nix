{ config, lib, pkgs, ... }: {
  programs.hyprland.enable = true;
  # Add a terminal 
  # So the default super + m keybind works
  environment.systemPackages = [ pkgs.kitty ];
  
  # Enable networkmanager
  networking.networkmanager.enable = true;
  imports = [
    ./sddm.nix
  ];
}