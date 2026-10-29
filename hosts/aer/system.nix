{
  system.etc.overlay.enable = false;
  users.mutableUsers = false;
  users.users."root".hashedPasswordFile = "/persist/root.pw";

  services.auto-cpufreq.enable = true;

  nix.settings.trusted-users = ["@1f87dcaa-49bb-4c52-9ee5-0f3ec42b682c"];

  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
  };
}
