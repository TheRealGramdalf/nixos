# Isengard: Offsite backup pool matching hosts/aer/tank in capacity
{
  disko.devices = {
    zpool."isengard" = {
      type = "zpool";
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

      datasets = {};
      postCreateHook = "zfs snapshot -r isengard@blank";
    };
  };
}
