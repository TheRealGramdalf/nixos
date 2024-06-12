# UEFI only GPT
{
  disko.devices = {
    disk."zdisk" = {
      ##### CHANGE THIS!! #####
      device = "/dev/disk/by-id/";
      ##### ^^^^^^^^^^^^^ #####
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          "aerwiar-zroot" = {
            label = "aerwiar-zroot";
            end = "-512M"; # Negative end means "Leave this much empty space at the end of the device"
            content = {
              type = "zfs";
              pool = "aerwiar-zroot";
            };
          };
          "aerwiar-zboot" = {
            label = "aerwiar-zboot";
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
    zpool."aerwiar-zroot" = {
      type = "zpool";
      options.ashift = "12";
      rootFsOptions = {
        # These are inherited to all child datasets as the default value
        mountpoint = "none";
        compression = "zstd";
        xattr = "sa";
        acltype = "posix";
      };

      datasets = {
        "ephemeral" = {
          type = "zfs_fs";
          options = {
            canmount = "noauto";
            mountpoint = "legacy";
          };
        };
        "ephemeral/nix" = {
          type = "zfs_fs";
          mountpoint = "/nix";
          options = {
            atime = "off";
            canmount = "noauto";
            mountpoint = "legacy"; # See https://github.com/nix-community/disko/issues/298#issuecomment-1949322912
          };
        };
        "safe" = {
          type = "zfs_fs";
          options = {
            canmount = "noauto";
            mountpoint = "legacy";
          };
        };
        "safe/persist" = {
          type = "zfs_fs";
          mountpoint = "/persist";
          options = {
            canmount = "noauto";
            mountpoint = "legacy"; # See https://github.com/nix-community/disko/issues/298#issuecomment-1949322912
          };
        };
        "safe/home" = {
          type = "zfs_fs";
          mountpoint = "/home";
          options = {
            canmount = "noauto";
            mountpoint = "legacy"; # See https://github.com/nix-community/disko/issues/298#issuecomment-1949322912
          };
        };
        "system-state" = {
          type = "zfs_fs";
          mountpoint = "/";
          options = {
            canmount = "noauto";
            mountpoint = "legacy";
          };
        };
      };
      postCreateHook = "zfs snapshot -r zroot@blank";
    };
  };
}
