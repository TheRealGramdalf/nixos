# Isengard: Offsite backup pool matching hosts/aer/tank in capacity
let
  fullzfs = {
    type = "disk";
    content = {
      type = "gpt";
      partitions."zfs" = {
        size = "100%";
        content = {
          type = "zfs";
          pool = "isengard";
        };
      };
    };
  };
  vd1-1 = {device = "/dev/disk/by-id/wwn-0x5000c500626b52eb";} // fullzfs;
  vd1-2 = {device = "/dev/disk/by-id/wwn-0x5000c500638b7f17";} // fullzfs;
  vd1-3 = {device = "/dev/disk/by-id/wwn-0x5000c5008370435f";} // fullzfs;
  vd1-4 = {device = "/dev/disk/by-id/wwn-0x50014ee263d62711";} // fullzfs;
  vd1-5 = {device = "/dev/disk/by-id/wwn-0x50014ee263d636da";} // fullzfs;
  vd1-6 = {device = "/dev/disk/by-id/wwn-0x5000c50083702c0f";} // fullzfs;
in {
  disko.devices = {
    disk = {
      inherit vd1-1 vd1-2 vd1-3 vd1-4 vd1-5 vd1-6;
    };
    zpool."isengard" = {
      type = "zpool";
      mode.topology = {
        type = "topology";
        vdev = [
          {
            mode = "raidz2";
            members = [
              "vd1-1"
              "vd1-2"
              "vd1-3"
              "vd1-4"
              "vd1-5"
              "vd1-6"
            ];
          }
        ];
      };
      options.ashift = "12";
      rootFsOptions = {
        # These are inherited to all child datasets as the default value
        canmount = "on"; # ...Except for `canmount`
        atime = "off"; # atime generally sucks, only enable it when needed
        compression = "zstd"; # More CPU heavy, but better compressratio
        xattr = "sa"; # Store extra attributes with metadata, good for performance
        acltype = "posix"; # Allows extra attributes i.e. SELinux/SMB
        dnodesize = "auto"; # Requires a feature (ZFS 0.8.4+), but sizes metadata nodes more efficiently
        normalization = "formD"; # Validate and normalize file names, good for SMB
      };

      datasets = {
        "sink".type = "zfs_fs";
      };
      postCreateHook = "zpool upgrade isengard";
    };
  };
}
