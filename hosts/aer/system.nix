{pkgs, ...}: {
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
    (final: prev: {
      bun = prev.bun.overrideAttrs {
          passthru.sources."x86_64-linux" = pkgs.fetchurl {
          url = "https://github.com/oven-sh/bun/releases/download/bun-v1.3.13/bun-linux-x64-baseline.zip";
          hash = "sha256-nYokKSpwaAkCBdqsCloiP19pc29Sh+N7+I07QDHtx1A=";
        };
      };
    })
  ]
  ;
}
