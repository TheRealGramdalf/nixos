{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    lsd # ls deluxe
    neovim # Text editor
    git # Version control
    sysz # Systemctl TUI
    tealdeer # TL;DR for linux commands
  ];
}
