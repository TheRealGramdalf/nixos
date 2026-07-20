{
  boot.initrd.systemd.enable = true;
  system.etc.overlay.enable = false;
  users.mutableUsers = false;
  users.users."root".hashedPasswordFile = "/persist/root.pw";

  services.auto-cpufreq.enable = true;

  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
  };
  nixpkgs.overlays = [
    (prev: final: {
      bun = prev.bun.override {
        src = builtins.fetchurl {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v1.3.13/bun-linux-x64-baseline.zip";
        hash = "";
      };
      };
    })
  ]
  ;
}
