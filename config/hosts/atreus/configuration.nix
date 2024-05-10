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
    kanidm.unixSettings.pam_allowed_login_groups = ["atreus-login"];
  };
}
