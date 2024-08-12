# Tank: Mirror of two 1TB disks
let
  pool = "tank";
  diskid-1 = "ata-WDC_WD10EZEX-00RKKA0_WD-WCC1S2272773";
  diskid-2 = "ata-WDC_WD10EZEX-00RKKA0_WD-WCC1S4020100";
  fullzfs = {
    type = "disk";
    content = {
      type = "gpt";
      partitions."${pool}" = {
        size = "100%";
        content = {
          type = "zfs";
          pool = "${pool}";
        };
      };
    };
  };
in {
  disko.devices = {
    disk."${pool}-1" =
      {
        device = "/dev/disk/by-id/${diskid-1}";
      }
      // fullzfs;
    disk."${pool}-2" =
      {
        device = "/dev/disk/by-id/${diskid-2}";
      }
      // fullzfs;
    zpool."${pool}" = {
      type = "zpool";
      options.ashift = "12";
      rootFsOptions = {
        # These are inherited to all child datasets as the default value
        canmount = "on"; # ...Except for `canmount`
        mountpoint = "/tank";
        atime = "off"; # atime generally sucks, only enable it when needed
        compression = "zstd"; # More CPU heavy, but better compressratio
        xattr = "sa"; # Store extra attributes with metadata, good for performance
        acltype = "posix"; # Allows extra attributes i.e. SELinux/SMB
        dnodesize = "auto"; # Requires a feature (ZFS 0.8.4+), but sizes metadata nodes more efficiently
        normalization = "formD"; # Validate and normalize file names, good for SMB
      };

      datasets = {
        "smb".type = "zfs_fs";
        "smb/photos" = {
          type = "zfs_fs";
          options = {
            atime = "on";
            recordsize = "1M";
          };
        };
        "media" = {
          type = "zfs_fs";
          options = {
            atime = "on";
            recordsize = "1M";
          };
        };
      };
      postCreateHook = "zfs snapshot -r tank@blank";
    };
  };
}
