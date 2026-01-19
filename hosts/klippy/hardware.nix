_: {
  boot.zfs = {
    devNodes = "/dev/disk/by-partlabel";
  };

  hardware.enableAllFirmware = true;
  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" = {
    device = "klippy-zroot/system-state";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "klippy-zroot/ephemeral/nix";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "klippy-zroot/safe/persist";
    fsType = "zfs";
    # Required for `hashedPasswordFile` etc. to work properly
    neededForBoot = true;
  };

  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/klippy-zboot";
    fsType = "vfat";
    neededForBoot = false;
  };
}
