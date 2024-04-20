{
  users.users = {
    "meebling".hashedPasswordFile = "/etc/passwdfile.meebling";
    "meeblingthedevilish".hashedPasswordFile = "/etc/passwdfile.meeblingthedevilish";
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
