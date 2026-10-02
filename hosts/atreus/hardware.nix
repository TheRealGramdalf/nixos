{
  config,
  lib,
  ...
}: {
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usbhid"];
  boot.kernelModules = ["kvm-amd"];

  hardware.enableAllFirmware = true;

  boot.zfs = {
    #STATEVERSION
    forceImportRoot = false;
    devNodes = "/dev/disk/by-partlabel";
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
    options = ["fmask=0022" "dmask=0022"];
    neededForBoot = false;
  };

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
