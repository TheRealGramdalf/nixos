{ config, pkgs, lib, ... }: {
  imports = [
    # Commonly used config
    ../../common/posix-client.nix
    ../../common/avahi-client.nix
    ../../common/zfs-boot.nix
    ../../common/pipewire.nix
    ../../common/tomeutils.nix
    ../../common/fonts.nix

    # Host-specific config
    ./hardware-config.nix
    ./configuration.nix
    ./hypr/hypr.nix
    ./nvidia.nix
  ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";
  networking = {
    hostName = "atreus";
    hostId = "e8ad1367";
  };
}