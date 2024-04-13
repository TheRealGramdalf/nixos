{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Commonly used config
    ../../common/avahi-client.nix
    ../../common/zfs-boot.nix
    ../../common/pipewire.nix

    # Host-specific config
    ./hardware-config.nix
    ./configuration.nix
    ./framework.nix
    ./hypr/hypr.nix
  ];
  system.stateVersion = "24.05";
  nixpkgs.config.allowUnfree = true;
  networking = {
    hostName = "aerwiar";
    hostId = "16a85224";
  };
}
