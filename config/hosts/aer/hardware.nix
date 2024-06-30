_: {
  boot.zfs = {
    extraPools = [
      "tank"
      "medusa"
    ];
  };

  fileSystems."/" = {
    device = "aer-zpool/system-state";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "aer-zpool/ephemeral/nix";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "aer-zpool/safe/persist";
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
