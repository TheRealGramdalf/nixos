{
  modulesPath,
  lib,
  ...
}: {
  imports = [
    # Commonly used config
    ../../common/zfs-boot.nix
    ../../common/tomeutils.nix
    ../../common/nh.nix
    ../../common/ntfs.nix
    ../../common/treewide-defaults.nix
    ../../common/backdoor.nix

    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
  ];

  # sudo-rs conflicts with install cd module
  security.sudo.enable = lib.mkForce false;

  time.timeZone = "America/Vancouver";
  system.stateVersion = "26.11";
  i18n.defaultLocale = "en_US.UTF-8";
  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.config = {
    allowUnfree = true;
  };
  networking = {
    hostName = "guiso";
    #hostId = "16a85224";
  };
}
