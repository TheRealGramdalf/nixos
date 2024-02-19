# BIOS compatible gpt partition
{
  disko.devices = {
    disk."zdisk" = {
      ##### CHANGE THIS!! #####
      device = "/dev/sdb";
      ##### ^^^^^^^^^^^^^ #####
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          # This allows a GPT partition table to be used with legacy BIOS systems. See https://www.gnu.org/software/grub/manual/grub/html_node/BIOS-installation.html
          "mbr" = {
            label = "mbr";
            size = "1M";
            type = "EF02";
          };
          "zroot" = {
            label = "zroot";
            end = "-512M"; # Negative end means "Leave this much empty space at the end of the device"
            content = {
              type = "zfs";
              pool = "zroot";
          };};
          "ZSYS" = {
            label = "ZSYS";
            size = "100%";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
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
            mountpoint = "legacy"; # See https://github.com/nix-community/disko/issues/298#issuecomment-1949322912
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
            mountpoint = "legacy"; # See https://github.com/nix-community/disko/issues/298#issuecomment-1949322912
        };};
        "safe/home" = {
          type = "zfs_fs";
          mountpoint = "/home";
          options = {
            canmount = "noauto";
            mountpoint = "legacy"; # See https://github.com/nix-community/disko/issues/298#issuecomment-1949322912
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

#zpool create -o ashift=12 -O compression=zstd -O xattr=sa -O acltype=posix -O mountpoint=none -R /mnt aerwiar-zpool /dev/disk/by-partlabel/aerwiar-zpool
#zfs create -o canmount=noauto -o mountpoint=legacy aerwiar-zpool/ephemeral
#zfs create -o canmount=noauto -o mountpoint=legacy aerwiar-zpool/safe
#zfs create -o canmount=noauto -o mountpoint=legacy aerwiar-zpool/system-state
#zfs create -o readonly=on aerwiar-zpool/system-state/boot
#zfs create -o readonly=on aerwiar-zpool/safe/home
#zfs create aerwiar-zpool/safe/home/gramdalf
#zfs create -o atime=off aerwiar-zpool/ephemeral/nix
#zfs snap -r aerwiar-zpool@blank
#zfs create -o canmount=noauto aerwiar-zpool/safe/persist