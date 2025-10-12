{pkgs, ...}: {
  boot.kernelPackages = pkgs.linuxPackages_6_16;
  #boot.zfs = {
  #enabled = true; # This is enabled automatically
  #devNodes = /dev/disk/by-partlabel; # Might have issues with legacy BIOS, since it can't read GPT labels?
  #};
  # Zram might be causing double compression and causing the system to hang in an OOM state
  zramSwap = {
    enable = false;
  };
}
