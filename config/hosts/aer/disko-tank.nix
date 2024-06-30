# Tank: Beefy boi with lots of space
{
  disko.devices = {
    zpool."tank" = {
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
        dnodesize = "auto"; # Requires a feature, but sizes metadata nodes more efficiently
        normalization = "formD"; # Validate and normalize file names, good for SMB
      };

      datasets = {
        "smb" = {
          type = "zfs_fs";
        };
        "photos" = {
          type = "zfs_fs";
          options.atime = "on";
        };
        "paperless" = {
          type = "zfs_fs";
        };
        "media" = {
          type = "zfs_fs";
          options.atime = "on";
        };
      };
      postCreateHook = "zfs snapshot -r tank@blank";
    };
  };
}
