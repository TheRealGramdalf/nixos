{config, ...}: {
  imports = [
    # Commonly used config
    #../../common/posix-client.nix
    ../../common/zfs-boot.nix
    ../../common/tomeutils.nix
    ../../common/fonts.nix
    ../../common/nh.nix
    ../../common/backdoor.nix

    # Host-specific config
    ./hardware.nix
    ./configuration.nix
    ./nvidia.nix
    ./basilisk.nix
    ./huion.nix
  ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";
  networking = {
    hostName = "atreus";
    hostId = "e8ad1367";
  };
}
