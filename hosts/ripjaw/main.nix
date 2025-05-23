{config, ...}: {
  imports = [
    # Commonly used config
    ../../common/zfs-boot.nix
    ../../common/tomeutils.nix
    ../../common/nh.nix
    ../../common/backdoor.nix
    ./netbird.nix

    # Host-specific config
    ./hardware.nix
    ./configuration.nix
    ./arm.nix
    ./kani.nix
  ];
  time.timeZone = "America/Vancouver";
  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";
  networking = {
    hostName = "ripjaw";
    hostId = "a4ed175a";
  };
}
