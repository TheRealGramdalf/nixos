_: {
  boot.zfs = {
    devNodes = "/dev/disk/by-partlabel";
    extraPools = [
      #"tank"
      #"medusa"
    ];
  };

  boot.initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ata_piix" "mpt3sas" "mvsas" "mptsas" "usb_storage" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];

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

  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/aer-zboot";
    fsType = "vfat";
    neededForBoot = false;
  };
}
