{
  hardware.enableAllFirmware = true;
  boot = {
    zfs = {
      devNodes = "/dev/disk/by-partlabel";
    };
    initrd.availableKernelModules = ["ahci" "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" "sdhci_pci"];
    initrd.kernelModules = ["dm-snapshot"];
    kernelModules = ["kvm-intel"];
  };

  fileSystems."/" = {
    device = "klippy-zroot/system-state";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "klippy-zroot/ephemeral/nix";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/klippy-zboot";
    fsType = "vfat";
    neededForBoot = false;
  };
}
