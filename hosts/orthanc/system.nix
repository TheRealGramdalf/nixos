{pkgs, ...}: {
  boot.initrd.systemd.enable = true;
  users.mutableUsers = false;
  users.users."root".hashedPasswordFile = "/persist/secrets/root.pw";
  environment.systemPackages = [
    pkgs.tmux
  ];
}
