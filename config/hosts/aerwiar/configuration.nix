{pkgs, ...}: {
  # Enable GVFS for SMB etc. mounts in userspace
  services.gvfs.enable = true;

  boot = {
    loader.systemd-boot.enable = true;
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
  environment.systemPackages = [pkgs.ntfs3g];
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

  hardware.opengl.extraPackages = with pkgs; [
    libva
    libvdpau
  ];

  services = {
    kanidm.enableClient = true;
    kanidm.clientSettings.uri = "https://auth.aer.dedyn.io";
    fwupd.enable = true;
  };
  users.users."gramdalf".shell = pkgs.nushellFull;

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  # Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "overlay2";
  programs = {
    wireshark.enable = true;
    adb.enable = true;
  };
  tomeutils = {
    vapor.enable = true;
    adhde.enable = true;
  };
}
