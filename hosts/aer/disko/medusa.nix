# Medusa: dual mirrored SSD pool for service data
let
  pool = "medusa";
  disk = {
    "intel-1" = "disk/by-id/ata-INTEL_SSDSC2BP480G4_BTJR4423020Y480BGN";
    "intel-2" = "disk/by-id/ata-INTEL_SSDSC2BP480G4_BTJR4423014N480BGN";
  };
in {
  disko.devices = {
    disk = {
      "intel-1" = {
        type = "disk";
        device = "/dev/${disk.intel-1}";
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
        device = "/dev/${disk.intel-2}";
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
        "secrets" = {
          type = "zfs_fs";
          options = {
            canmount = "on";
            mountpoint = "/persist/secrets";
          };
        };
        "secrets/traefik".type = "zfs_fs";
        "services" = {
          type = "zfs_fs";
          options = {
            canmount = "on";
            mountpoint = "/persist/services";
          };
        };
        "services/kanidm".type = "zfs_fs";
        "services/kanidm/db" = {
          type = "zfs_fs";
          options = {
            # To keep in sync with the Kanidm DB
            recordsize = "64k";
          };
        };
        "services/vaultwarden".type = "zfs_fs";
        "services/traefik".type = "zfs_fs";
        "services/dashy".type = "zfs_fs";
        "services/jellyfin".type = "zfs_fs";
        "services/paperless".type = "zfs_fs";
        "services/home-assistant".type = "zfs_fs";
      };
      postCreateHook = "zfs snapshot -r ${pool}@blank";
    };
  };
}
