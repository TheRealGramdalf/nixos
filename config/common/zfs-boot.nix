{
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.zfs = {
    enabled = true;
    devNodes = /dev/disk/by-partlabel;
  };
  # Since swapfile isn't available, enable zramswap
  zramSwap.enable = true;
}