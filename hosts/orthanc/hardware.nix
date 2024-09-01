{config, ...}: let
  hostname = config.networking.hostName;
in {
  boot.zfs = {
    devNodes = "/dev/disk/by-partlabel";
    extraPools = [
      "orthanc"
    ];
  };

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "ehci_pci" "ahci" "aacraid" "usbhid" "sd_mod"];
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

  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/${hostname}-zboot";
    fsType = "vfat";
    neededForBoot = false;
  };
}
