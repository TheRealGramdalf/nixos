{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware.nix
    ./networking.nix
    ./services/main.nix
    ./ssh.nix
    ./configuration.nix
  ];
  networking = {
    hostName = "eyemac";
    hostId = "8425e349";
  };
  time.timeZone = "America/Vancouver";
  system.stateVersion = "24.05";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableRedistributableFirmware = true;
  environment.systemPackages = with pkgs; [
    git
    sysz
    neovim
  ];
}
