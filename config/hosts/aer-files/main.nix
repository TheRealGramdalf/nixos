{ config, pkgs, lib, modulesPath, ... }: {
  imports = [
    # Commonly used config
    ../../common/posix-client.nix
    ../../common/avahi-client.nix

    # Host-specific config
    ./hardware-config.nix
    ./configuration.nix
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
  ];
  system.stateVersion = "24.05";
  networking.hostName = "aer-files";
}