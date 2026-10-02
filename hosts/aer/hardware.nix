{
  boot = {
    zfs = {
      devNodes = "/dev/disk/by-partlabel";
      extraPools = [
        "tank"
        "medusa"
      ];
      #STATEVERSION
      forceImportRoot = false;
    };
    initrd.availableKernelModules = ["uhci_hcd" "ehci_pci" "ata_piix" "mpt3sas" "mvsas" "mptsas" "usb_storage" "usbhid" "sd_mod"];
    kernelModules = ["kvm-intel"];
  };

  hardware.enableAllFirmware = true;

  fileSystems."/" = {
    device = "aer-zroot/system-state";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "aer-zroot/ephemeral/nix";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "aer-zroot/safe/persist";
    fsType = "zfs";
    # Required for `hashedPasswordFile` etc. to work properly
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/aer-zboot";
    fsType = "vfat";
    neededForBoot = false;
  };
}
