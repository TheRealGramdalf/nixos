{
  config,
  lib,
  ...
}: let
  hostname = config.networking.hostName;
in {
  hardware = {
    bluetooth.enable = true;
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    # Fixes iwlwifi not loading
    enableAllFirmware = true;
  };

  services = {
    # Enable fingerprint reader
    fprintd.enable = false;
    # Control the malfunctioning fan
    thinkfan.enable = true;
  };
  specialisation."no-thinkfan".configuration = {
    services.thinkfan.enable = lib.mkForce false;
  };

  boot = {
    zfs = {
      #STATEVERSION
      forceImportRoot = false;
      devNodes = "/dev/disk/by-partlabel";
    };
    kernelParams = [
      "zfs.zfs_arc_sys_free=3221225472" # 3GiB
    ];
    initrd.availableKernelModules = ["xhci_pci" "nvme" "uas" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
    kernelModules = ["kvm-intel"];
  };

  fileSystems."/" = {
    device = "${hostname}-zroot/system-state";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "${hostname}-zroot/ephemeral/nix";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "${hostname}-zroot/safe/persist";
    fsType = "zfs";
    # Required for `hashedPasswordFile` etc. to work properly
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/${hostname}-zboot";
    fsType = "vfat";
    neededForBoot = false;
  };
}
