{
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  
  boot.loader.grub = {
    e = true;
  };

  fileSystems."/" =
    { device = "zroot/system-state";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/60BA-4855";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "zroot/safe/home";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    { device = "zroot/ephemeral/nix";
      fsType = "zfs";
    };

  fileSystems."/persist" =
    { device = "zroot/safe/persist";
      fsType = "zfs";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.ens18.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
