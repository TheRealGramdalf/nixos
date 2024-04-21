{
  users.users = {
    "meebling".hashedPasswordFile = "/persist/secrets/passwdfile.meebling";
    "meeblingthedevilish".hashedPasswordFile = "/persist/secrets/passwdfile.meeblingthedevilish";
  };
  hardware.enableRedistributableFirmware = true;
  services = {
    openssh = {
      openFirewall = true;
      enable = true;
    };
    kanidm.unixSettings.pam_allowed_login_groups = ["atreus-login"];
  };
}
