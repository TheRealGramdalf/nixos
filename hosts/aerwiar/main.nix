{config, ...}: {
  imports = [
    # Commonly used config
    ../../common/zfs-boot.nix
    ../../common/tomeutils.nix
    ../../common/nh.nix

    # Host-specific config
    ./hardware.nix
    ./configuration.nix
    ./kde.nix
    ./netbird.nix
    ./localsend.nix
    ./fwmm.nix
    #./fprint.nix
  ];
  time.timeZone = "America/Vancouver";
  system.stateVersion = "24.05";
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "libsoup-2.74.3"
    ];
  };
  networking = {
    hostName = "aerwiar";
    hostId = "16a85224";
  };
}
