{
  imports = [
    # Commonly used config
    ../../common/zfs-boot.nix
    ../../common/tomeutils.nix
    ../../common/nh.nix
    ../../common/backdoor.nix
    ../../common/posix-client.nix
    ../../common/ntfs.nix
    ../../common/msfonts.nix
    ../../common/hyperlegible.nix
    ../../common/treewide-defaults.nix
    ../../common/kde.nix

    # Host-specific config
    ./hardware.nix
    ./configuration.nix
    ./peripherals.nix
    ./users.nix
    ./timekpr.nix
    ./kanidm.nix
  ];
  time.timeZone = "America/Vancouver";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";
  networking = {
    hostName = "atreus";
    hostId = "e8ad1367";
  };
}
