{pkgs, ...}: {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
      };
      timeout = 0;
    };
    zfs.devNodes = "/dev/disk/by-partlabel";
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
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    kanidm.enableClient = true;
    kanidm.clientSettings.uri = "https://auth.aer.dedyn.io";
    kanidm.package = pkgs.kanidm_1_6;
    fwupd.enable = true;
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      vhostUserPackages = [pkgs.virtiofsd]; # Enables virtiofs shares
      #package = pkgs.qemu_kvm; # Look into, to save disk space?
    };
  };
  programs.virt-manager.enable = true;
  # Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false; # This increases startup time by 10 seconds on it's own. Not useful unless docker is always running.
  };
  virtualisation.docker.storageDriver = "overlay2";
  programs = {
    wireshark.enable = true;
    adb.enable = true;
  };
  tomeutils = {
    vapor.enable = true;
    #adhde.enable = true;
  };
}
