{
  users.mutableUsers = false;

  services.auto-cpufreq.enable = true;

  programs.nh = {
    flake = "/etc/nixos";
  };
}
