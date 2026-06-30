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
    ./users.nix
    #./fprint.nix
  ];
  time.timeZone = "America/Vancouver";
  system.stateVersion = "24.05";
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-39.8.10"
      "pnpm-10.29.2"
    ];
    nvidia.acceptLicense = true;
  };
  networking = {
    hostName = "aerwiar";
    hostId = "16a85224";
  };
}
