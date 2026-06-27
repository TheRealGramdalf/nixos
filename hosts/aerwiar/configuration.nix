{
  pkgs,
  lib,
  ...
}: {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
      };
      timeout = 0;
    };
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

  nix.settings = {
    # Should be automatic with auto-allocate-uids, not working due to bug?
    system-features = [ "uid-range" ];
    auto-allocate-uids = true;
    auto-optimise-store = true;
    experimental-features = [
      "cgroups"
      "auto-allocate-uids"
      "nix-command"
      "flakes"
    ];
  };

  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    kanidm.client = {
      enable = true;
      settings.uri = "https://auth.aer.dedyn.io";
    };
    kanidm.package = pkgs.kanidm_1_10;
    fwupd.enable = true;
  };


  virtualisation.libvirtd = {
    enable = true;
    # Don't autostart previously running VMs
    onBoot = "ignore";
    qemu = {
      vhostUserPackages = [pkgs.virtiofsd]; # Enables virtiofs shares
      #package = pkgs.qemu_kvm; # Look into, to save disk space?
    };
  };
  # Make libvirtd only socket activated
  systemd.services.libvirtd.wantedBy = lib.mkForce [];

  programs.virt-manager.enable = true;
  # Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false; # This increases startup time by 10 seconds on it's own. Not useful unless docker is always running.
  };
  virtualisation.docker.storageDriver = "overlay2";
  programs = {
    wireshark.enable = false;
  };

  services.udev.packages = [ pkgs.vial ];
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
