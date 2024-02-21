{ config, pkgs, lib, modulesPath, ... }: {
  imports = [
    # Commonly used config
    ../../common/posix-client.nix

    # Host-specific config
    ./configuration.nix
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
  ];
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.05";
  networking.hostName = "docker-ve";
}