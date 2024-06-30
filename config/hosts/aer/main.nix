{config, ...}: {
  imports = [
    #./docker.nix
    ./networking.nix
    ./hardware.nix
    
    # Services
    ./services/services.nix
  ];
  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";
  networking = {
    hostName = "aer";
    hostId = "943c5a42";
  };
}
