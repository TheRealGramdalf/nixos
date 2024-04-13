{config, ...}: {
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  #boot.zfs = {
  #enabled = true; # This is enabled automatically
  #devNodes = /dev/disk/by-partlabel; # Might have issues with legacy BIOS, since it can't read GPT labels?
  #};
  # Since swapfile isn't available, enable zramswap
  zramSwap.enable = true;
}
