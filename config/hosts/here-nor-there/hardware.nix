{
  config,
  lib,
  ...
}: {
  boot.initrd.availableKernelModules = ["xhci_pci" "ehci_pci" "usbhid" "usb_storage" "sd_mod"];
  boot.zfs = {
    devNodes = "/dev/disk/by-partlabel";
    extraPools = [
      "tank"
    ];
  };

  boot.loader.timeout = 0;
  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
  };

  fileSystems."/" = {
    device = "herenorthere-zroot/system-state";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "herenorthere-zroot/ephemeral/nix";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "herenorthere-zroot/safe/persist";
    fsType = "zfs";
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/herenorthere-zboot";
    fsType = "vfat";
    neededForBoot = false;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
