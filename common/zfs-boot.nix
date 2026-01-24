{pkgs, ...}: {
  boot.kernelPackages = pkgs.linuxPackages_6_18;
  boot.zfs.package = pkgs.zfs_2_4;
  #boot.zfs = {
  #enabled = true; # This is enabled automatically
  #devNodes = /dev/disk/by-partlabel; # Might have issues with legacy BIOS, since it can't read GPT labels?
  #};
  zramSwap = {
    enable = true;
  };
}
