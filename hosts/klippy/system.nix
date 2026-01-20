_: {
  users.mutableUsers = false;

  services.auto-cpufreq.enable = true;

  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
  };
}
