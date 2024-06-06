{
  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL5ibKzd+V2eR1vmvBAfSWcZmPB8zUYFMAN3FS6xY9ma"
  ];
  hardware.enableRedistributableFirmware = true;
  services = {
    openssh = {
      openFirewall = true;
      enable = true;
    };
  };

  systemd.sysusers.enable = true;
  system.etc.overlay.enable = true;
  boot.initrd.systemd.enable = true;

  tomeutils = {
    vapor.enable = true;
    adhde.enable = true;
  };
}
