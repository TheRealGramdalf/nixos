{ config, ... }: {
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.zfs = {
    #enabled = true; # This is enabled automatically
    devNodes = /dev/disk/by-partlabel;
  };
  # Since swapfile isn't available, enable zramswap
  zramSwap.enable = true;
}