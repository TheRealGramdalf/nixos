{pkgs, ...}: {
  boot.kernelPackages = pkgs.linuxPackages_6_6;
  #boot.zfs = {
  #enabled = true; # This is enabled automatically
  #devNodes = /dev/disk/by-partlabel; # Might have issues with legacy BIOS, since it can't read GPT labels?
  #};
  # Since swapfile isn't available, enable zramswap
  zramSwap = {
    enable = true;
    memoryPercent = 60;
  };
}
