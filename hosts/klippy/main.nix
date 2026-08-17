{pkgs, ...}: {
  imports = [
    ../../common/tomeutils.nix
    ../../common/zfs-boot.nix
    ../../common/nix3.nix
    ../../common/nh.nix

    ./networking.nix
    ./hardware.nix
    ./ssh.nix
    ./system.nix
    ./klipper.nix
  ];
  time.timeZone = "America/Vancouver";
  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";
  networking = {
    hostName = "klippy";
    hostId = "0593d40c";
  };

  environment.systemPackages = with pkgs; [
    smartmontools # SMART monitoring for block devices
  ];
}
