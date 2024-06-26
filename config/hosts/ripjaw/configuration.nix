{
  hardware.enableRedistributableFirmware = true;
  services.kanidm.unixSettings.pam_allowed_login_groups = ["ripjaw-login"];

  # Enable 24.05 /etc overlay
  #systemd.sysusers.enable = true;
  system.etc.overlay.enable = true;
  boot.initrd.systemd.enable = true;

  #users.users."cbe7b78d-c5ac-48cc-9615-b8117b4d4b77".extraGroups = ["video" "netdev"];

  tomeutils = {
    vapor.enable = true;
    adhde.enable = true;
  };
}
