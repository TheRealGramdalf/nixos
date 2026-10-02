{
  networking.networkmanager.wifi.powersave = true;
  boot.kernelParams = [
    "zfs.zfs_arc_sys_free=3221225472" # 3GiB
  ];
}