{config, ...}: {
  imports = [
    ../../common/tomeutils.nix
    ../../common/zfs-boot.nix
    ../../common/backdoor.nix
    ./configuration.nix
    ./hardware.nix
    ./specializations.nix
    ./kde.nix
  ];
  time.timeZone = "America/Vancouver";
  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.11";
  networking = {
    hostName = "muffin-time";
    hostId = "04ff6c6c";
  };
}
