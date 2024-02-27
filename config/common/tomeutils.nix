{ config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    lsd # ls deluxe
    neovim # Text editor
    git # Version control
  ];
}