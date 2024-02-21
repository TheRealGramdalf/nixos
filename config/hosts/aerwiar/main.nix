{ config, pkgs, lib, ... }: {
  imports = [
    # Commonly used config
    ../../common/avahi-client.nix
    ../../common/zfs-boot.nix

    # Host-specific config
    ./hardware-config.nix
    ./configuration.nix
  ];
  system.stateVersion = "24.05";
  networking = {
    hostName = "aerwiar";
    hostId = "16a85224";
  };
}