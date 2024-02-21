{ config, pkgs, lib, modulesPath, ... }: {
  imports = [
    # Commonly used config
    ../../common/posix-client.nix

    # Host-specific config
    ./configuration.nix
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
  ];
  system.stateVersion = "24.05";
  networking.hostName = "docker-ve";
}