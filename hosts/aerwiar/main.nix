{config, ...}: {
  imports = [
    # Commonly used config
    ../../common/zfs-boot.nix
    ../../common/tomeutils.nix
    ../../common/nh.nix

    # Host-specific config
    ./hardware.nix
    ./configuration.nix
    ./netbird.nix
    ./localsend.nix
    #./fprint.nix
  ];
  time.timeZone = "America/Vancouver";
  system.stateVersion = "24.05";
  nixpkgs.config.allowUnfree = true;
  networking = {
    hostName = "aerwiar";
    hostId = "16a85224";
  };
}
