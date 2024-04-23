{
  users.users = {
    "meebling" = {
      hashedPasswordFile = "/persist/secrets/passwdfile.meebling";
      extraGroups = ["video" "network"];
    };
    "meeblingthedevilish" = {
      hashedPasswordFile = "/persist/secrets/passwdfile.meeblingthedevilish";
      extraGroups = ["video" "network"];
    };
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
