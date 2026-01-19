_: {
  users.mutableUsers = false;
  users.users."root".hashedPasswordFile = "/persist/root.pw";

  services.auto-cpufreq.enable = true;

  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
  };
}
