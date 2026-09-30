{
  imports = [
    # Commonly used config
    ../../common/zfs-boot.nix
    ../../common/tomeutils.nix
    ../../common/nh.nix
    #../../common/lix.nix
    ../../common/systemd-boot.nix
    ../../common/posix-client.nix
    ../../common/ntfs.nix
    ../../common/msfonts.nix
    ../../common/hyperlegible.nix
    ../../common/treewide-defaults.nix

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
  i18n.defaultLocale = "en_US.UTF-8";
  nixpkgs.hostPlatform = "x86_64-linux";
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
