{...}: {
  boot.initrd.systemd.enable = true;
  system.etc.overlay.enable = true;
  users.mutableUsers = false;
  users.users."root".hashedPasswordFile = "/persist/secrets/root.pw";
}