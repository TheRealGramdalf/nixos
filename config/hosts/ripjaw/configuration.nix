{
  hardware.enableRedistributableFirmware = true;
  services = {
    openssh = {
      openFirewall = true;
      enable = true;
    };
    kanidm.unixSettings.pam_allowed_login_groups = ["ripjaw-login"];
  };
  tomeutils = {
    vapor.enable = true;
    adhde.enable = true;
  };
}
