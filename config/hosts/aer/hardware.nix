_: {

  boot.zfs = {
    extraPools = [
      "tank"
      "medusa"
      "aer-zpool"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/aer-zboot";
    fsType = "vfat";
    neededForBoot = false;
  };
}