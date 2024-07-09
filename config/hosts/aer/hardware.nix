_: {
  boot.zfs = {
    devNodes = "/dev/disk/by-partlabel";
    extraPools = [
      "tank"
      "medusa"
    ];
  };

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
