{pkgs, ...}: {
  boot.initrd.systemd.enable = true;
  system.etc.overlay.enable = false;
  users.mutableUsers = false;
  users.users."root".hashedPasswordFile = "/persist/root.pw";

  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
  };
}
