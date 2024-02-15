# BIOS compatible gpt partition
{
  disko.devices = {
    disk."zdisk" = {
      device = "/dev/sda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          # This allows a GPT partition table to be used with legacy BIOS systems. See https://www.gnu.org/software/grub/manual/grub/html_node/BIOS-installation.html
          "mbr" = {
            size = "1M";
            type = "EF02";
          };
          "ZSYS" = {
            end = "-512M"; # Negative size to place it at the end of the partition
            type = "EF00"; # ^^ Mostly desirable with resizeable partitions like BTRFS/EXT4, used here for compatibility
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
          };};
          "zroot" = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "zroot";
          };};
        };
      };
    };
    zpool."zroot" = {
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
        };};
        "ephemeral/nix" = {
          type = "zfs_fs";
          mountpoint = "/nix";
          options = {
            atime = "off";
            canmount = "noauto";
        };};
        "safe" = {
          type = "zfs_fs";
          options = {
            canmount = "noauto";
            mountpoint = "legacy";
        };};
        "safe/persist" = {
          type = "zfs_fs";
          mountpoint = "/persist";
          options = {
            canmount = "noauto";
        };};
        "safe/home" = {
          type = "zfs_fs";
          mountpoint = "/home";
          options = {
            canmount = "noauto";
        };};
        "system-state" = {
          type = "zfs_fs";
          mountpoint = "/";
          options = {
            canmount = "noauto";
            mountpoint = "legacy";
        };};
      };
      #preMountHook = "zfs snapshot -r zroot@blank";
      # Needs fixing, runs multiple times
    };
  };
}

# https://github.com/nix-community/disko/issues/298
# Configure disk format in line with `zpool`, rather than separately

#2024-02-06.13:05:06 zpool create -o ashift=12 -O compression=zstd -O xattr=sa -O acltype=posix -O mountpoint=none -R /mnt aerwiar-zpool /dev/disk/by-partlabel/aerwiar-zpool
#2024-02-06.13:05:06 zfs create -o canmount=noauto -o mountpoint=legacy aerwiar-zpool/ephemeral
#2024-02-06.13:05:06 zfs create -o canmount=noauto -o mountpoint=legacy aerwiar-zpool/safe
#2024-02-06.13:05:06 zfs create -o canmount=noauto -o mountpoint=legacy aerwiar-zpool/system-state
#2024-02-06.13:05:06 zfs create -o readonly=on aerwiar-zpool/system-state/boot
#2024-02-06.13:05:06 zfs create -o readonly=on aerwiar-zpool/safe/home
#2024-02-06.13:05:06 zfs create aerwiar-zpool/safe/home/gramdalf
#2024-02-06.13:05:06 zfs create -o atime=off aerwiar-zpool/ephemeral/nix
#2024-02-06.13:05:06 zfs snap -r aerwiar-zpool@blank
#2024-02-06.16:22:01 zpool import aerwiar-zpool -d /dev/disk/by-partlabel
#2024-02-06.16:29:37 zfs create -o canmount=noauto aerwiar-zpool/safe/persist