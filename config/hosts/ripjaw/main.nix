{ config, pkgs, ... }: {
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
  system.stateVersion = "24.05";
  networking = {
    hostName = "ripjaw";
    hostId = "a4ed175a";
  };
}