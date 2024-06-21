{config, ...}: {
  imports = [
    ./docker.nix
    ./networking.nix
    
    # Services
    ./services/services.nix
  ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";
  networking = {
    hostName = "aer";
    hostId = "943c5a42";
  };
}
