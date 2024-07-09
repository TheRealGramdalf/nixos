{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./docker.nix
    ./networking.nix
    ./hardware.nix
    ./ssh.nix
    ../../common/nix3.nix

    # Services
    ./services/services.nix
  ];
  time.timeZone = "America/Vancouver";
  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";
  networking = {
    hostName = "aer";
    hostId = "943c5a42";
  };

  environment.systemPackages = with pkgs; [
    git
    sysz
    neovim
  ];
}
