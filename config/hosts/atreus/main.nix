{config, ...}: {
  imports = [
    # Commonly used config
    #../../common/posix-client.nix
    ../../common/zfs-boot.nix
    ../../common/pipewire.nix
    ../../common/tomeutils.nix
    ../../common/fonts.nix
    ../../common/hypr/hypr.nix
    ../../common/nh.nix
    ../../common/lan.nix

    # Host-specific config
    ./hardware-config.nix
    ./configuration.nix
    ./nvidia.nix
  ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";
  networking = {
    hostName = "atreus";
    hostId = "e8ad1367";
  };
}
