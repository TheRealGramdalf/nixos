{ config, pkgs, lib, ... }: {
  imports = [
    # Commonly used config
    ../../common/posix-client.nix
    ../../common/avahi-client.nix
    ../../common/zfs-boot.nix

    # Host-specific config
    ./hardware-config.nix
    ./configuration.nix
    #./home.nix
  ];
  # Override zfs devnodes for running in a VM
  boot.zfs = lib.mkForce {
    devNodes = "/dev/disk/by-path";
  };
  system.stateVersion = "24.05";
  networking = {
    hostName = "ripjaw";
    hostId = "a4ed175a";
  };
}