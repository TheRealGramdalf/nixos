{
  config,
  lib,
  ...
}: let
  hostname = config.networking.hostName;
in {

  boot = {
    kernelParams = [
      "zfs.zfs_arc_sys_free=3221225472" # 3GiB
    ];
    initrd.availableKernelModules = ["xhci_pci" "nvme" "uas" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
    kernelModules = ["kvm-intel"];
  };

  # Fixes iwlwifi not loading
  hardware.enableAllFirmware = true;

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

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
