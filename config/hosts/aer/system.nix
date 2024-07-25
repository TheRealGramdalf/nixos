{...}: {
  boot.initrd.systemd.enable = true;
  system.etc.overlay.enable = true;
  users.mutableUsers = false;
}