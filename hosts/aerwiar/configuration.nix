{
  pkgs,
  lib,
  ...
}: {
  boot = {
    loader.timeout = 0;
    zfs = {
      devNodes = "/dev/disk/by-partlabel";
      # STATEVERSION
      forceImportRoot = false;
    };
    plymouth = {
      enable = true;
      theme = "catppuccin-mocha";
      themePackages = [
        (pkgs.catppuccin-plymouth.override {variant = "mocha";})
      ];
    };
    tmp.cleanOnBoot = true;
  };
  powerManagement = {
    enable = true;
    scsiLinkPolicy = "med_power_with_dipm";
  };

  ### Experimental
  boot.kernelParams = [
    "zfs.zfs_arc_sys_free=3221225472" # 3GiB
  ];
  systemd.oomd = {
    enableUserSlices = true;
    enableSystemSlice = true;
  };
  security.sudo-rs.enable = true;

  users = {
    groups."trusted-users" = {};
  };
  services.dbus.implementation = "broker";
  fonts.packages = [pkgs.liberation_ttf_v2];
  ###

  nix.settings = {
    trusted-users = ["@trusted-users"];
    # Should be automatic with auto-allocate-uids, not working due to bug?
    system-features = ["uid-range"];
    auto-allocate-uids = true;
    use-cgroups = true;
    experimental-features = [
      "cgroups"
      "auto-allocate-uids"
      "nix-command"
      "flakes"
    ];
  };

  services = {
    kanidm.client = {
      enable = true;
    };
    fwupd.enable = true;
  };
  
  programs = {
    wireshark.enable = false;
  };

  services.udev.packages = [pkgs.vial];
  hardware.keyboard.qmk.enable = true;
  environment.systemPackages = [
    pkgs.android-tools
    pkgs.qmk
    pkgs.vial
  ];
  tomeutils = {
    vapor = {
      enable = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
      extraPackages = [pkgs.gamescope];
    };
  };
  services.ollama.enable = true;
}
