{config, ...}: {
  imports = [
    ../../common/tomeutils.nix
    ./networking.nix
    ./hardware.nix
    ./ssh.nix
    ./system.nix
    ./zrepl.nix
  ];
  time.timeZone = "America/Vancouver";
  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";
  networking = {
    hostName = "orthanc";
    hostId = "864ae26d";
  };
}
