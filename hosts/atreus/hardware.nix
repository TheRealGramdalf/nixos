{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "usbhid" "uas" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  hardware.enableAllFirmware = true;

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_11;
  boot.zfs = {
    package = lib.mkForce pkgs.zfs_unstable;
    devNodes = "/dev/disk/by-partlabel";
  };

  boot = {
    plymouth.enable = true;
    tmp.cleanOnBoot = true;
    loader.systemd-boot.enable = true;
  };

  fileSystems."/" = {
    device = "atreus-zroot/system-state";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "atreus-zroot/safe/home";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "atreus-zroot/ephemeral/nix";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "atreus-zroot/safe/persist";
    fsType = "zfs";
    # Required for `hashedPasswordFile` to work properly
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/atreus-zboot";
    fsType = "vfat";
    neededForBoot = false;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
