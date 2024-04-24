{
  config,
  modulesPath,
  ...
}: {
  imports = [
    # Commonly used config
    ../../common/posix-client.nix
    ../../common/lan.nix

    # Host-specific config
    ./configuration.nix
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
  ];
  services.chrony.enable = false;
  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";
  networking.hostName = "aer-files";
}
