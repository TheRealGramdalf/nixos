# twotowers: mirrored HDD pool for A.R.M. rips
let
  pool = "twotowers";
  disk = {
    "intel-1" = "disk/by-id/wwn-0x5000c50002890a90";
    "intel-2" = "disk/by-id/wwn-0x5000c50002890ba4";
  };
in {
  disko.devices = {
    disk = {
      "intel-1" = {
        type = "disk";
        device = "/dev/${disk.hdd-1}";
        content = {
          type = "gpt";
          partitions."zfs" = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "${pool}";
            };
          };
        };
      };
      "intel-2" = {
        type = "disk";
        device = "/dev/${disk.hdd-2}";
        content = {
          type = "gpt";
          partitions."zfs" = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "${pool}";
            };
          };
        };
      };
    };
    zpool.${pool} = {
      type = "zpool";
      mode = "mirror";
      options.ashift = "12";
      rootFsOptions = {
        # These are inherited to all child datasets as the default value
        canmount = "off"; # ...Except for `canmount`
        mountpoint = "none"; # Don't mount the main pool anywhere
        atime = "off"; # atime generally sucks, only enable it when needed
        compression = "zstd"; # Slightly more CPU heavy, but better compressratio
        xattr = "sa"; # Store extra attributes with metadata, good for performance
        acltype = "posix"; # Allows extra attributes i.e. SELinux
        dnodesize = "auto"; # Requires a feature (ZFS 0.8.4+), but sizes metadata nodes more efficiently
        normalization = "formD"; # Validate and normalize file names, good for SMB
      };

      datasets = {
        "arm/paperless".type = "zfs_fs";
      };
    };
  };
}
