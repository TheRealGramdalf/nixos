_: {
  boot.initrd.systemd.enable = true;
  system.etc.overlay.enable = false;
  users.mutableUsers = false;
  users.users."root".hashedPasswordFile = "/persist/root.pw";

  services.auto-cpufreq.enable = true;

  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
  };
}
