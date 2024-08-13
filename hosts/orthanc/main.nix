{config, ...}: {
  imports = [
    ../../common/tomeutils.nix
    ./networking.nix
    ./hardware.nix
    ./ssh.nix
    ./system.nix
  ];
  time.timeZone = "America/Vancouver";
  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";
  networking = {
    hostName = "orthanc";
    hostId = "";
  };
}
