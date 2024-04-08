{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "uas" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot = {
    zfs.devNodes = "/dev/disk/by-partlabel";
    plymouth.enable = true;
    tmp.cleanOnBoot = true;
    loader.systemd-boot.enable = true;
  };
  

  fileSystems."/" =
    { device = "atreus-zroot/system-state";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-partlabel/atreus-zboot";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "atreus-zroot/safe/home";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    { device = "atreus-zroot/ephemeral/nix";
      fsType = "zfs";
    };

  fileSystems."/persist" =
    { device = "atreus-zroot/safe/persist";
      fsType = "zfs";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
