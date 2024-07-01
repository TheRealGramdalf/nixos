{lib, ...}: {
  # Fix ZFS devnodes in a VM
  boot.zfs.devNodes = lib.mkForce "/dev/disk/by-partuuid";
  # Add a password for logging in via the VM console
  users.users."root".password = "none";
  systemd.network.networks."20-ether" = {
    # Match all non-virtual (veth) ethernet connections
    matchConfig = {
      Type = "ether";
      Kind = "!*";
    };
    networkConfig = {
      DHCP = true;
    };
  };
  services.qemuGuest.enable = true;
}