# UEFI only GPT
let
  host = "klippy";
  diskid = "nvme-SK_hynix_BC501_HFM512GDJTNG-8310A_FJ88N652510408T41";
in {
  disko.devices = {
    disk."zdisk" = {
      device = "/dev/disk/by-id/${diskid}";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          "${host}-zroot" = {
            label = "${host}-zroot";
            end = "-1G"; # Negative end means "Leave this much empty space at the end of the device"
            content = {
              type = "zfs";
              pool = "${host}-zroot";
            };
          };
          "${host}-zboot" = {
            label = "${host}-zboot";
            size = "100%";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
        };
      };
    };
    zpool."${host}-zroot" = {
      type = "zpool";
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
      };

      datasets = {
        "ephemeral" = {
          type = "zfs_fs";
          options = {
            canmount = "off";
            mountpoint = "none";
          };
        };
        "ephemeral/nix" = {
          type = "zfs_fs";
          # fstab, not zfsprop
          mountpoint = "/nix";
          options = {
            mountpoint = "legacy";
          };
        };
        "safe" = {
          type = "zfs_fs";
          options = {
            canmount = "off";
            mountpoint = "none";
          };
        };
        "safe/persist" = {
          type = "zfs_fs";
          # fstab, not zfsprop
          mountpoint = "/persist";
          options = {
            mountpoint = "/persist";
          };
        };
        "safe/persist/services" = {
          type = "zfs_fs";
        };
        "safe/persist/services/klipper" = {
          type = "zfs_fs";
        };
        "safe/persist/services/moonraker" = {
          type = "zfs_fs";
        };
        "safe/persist/services/mainsail" = {
          type = "zfs_fs";
        };
        "system-state" = {
          type = "zfs_fs";
          # fstab, not zfsprop
          mountpoint = "/";
          options = {
            mountpoint = "legacy";
          };
        };
      };
      postCreateHook = "zfs snapshot -r ${host}-zroot@blank";
    };
  };
}
