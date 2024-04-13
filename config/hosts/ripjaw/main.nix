{
  config,
  pkgs,
  lib,
  ...
}: {
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
    ./hypr.nix
    ./arm.nix
    #./home.nix
  ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";
  networking = {
    hostName = "ripjaw";
    hostId = "a4ed175a";
  };
}
