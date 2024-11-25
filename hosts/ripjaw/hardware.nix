{
  config,
  lib,
  ...
}: {
  boot.initrd.availableKernelModules = ["ahci" "ohci_pci" "ehci_pci" "pata_atiixp" "firewire_ohci" "usb_storage" "sd_mod" "sr_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  boot.loader.grub = {
    enable = true;
    # This device needs to be an entire disk, not a partition!
    device = "/dev/disk/by-id/wwn-0x50025385500dc182";
  };

  fileSystems."/" = {
    device = "zroot/system-state";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "zroot/safe/home";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "zroot/ephemeral/nix";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "zroot/safe/persist";
    fsType = "zfs";
    # Required for `hashedPasswordFile` to work properly
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1B1B-D929";
    fsType = "vfat";
    neededForBoot = false;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
