_: {
  boot.initrd.systemd.enable = true;
  system.etc.overlay.enable = false;
  users.mutableUsers = false;
  users.users."root".hashedPasswordFile = "/persist/secrets/root.pw";

  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
    package = final: prev: {
      nh = prev.nh.overrideAttrs (oldAttrs: {
        patches =
          oldAttrs.patches
          ++ [
            (prev.fetchpatch2 {
              url = "https://github.com/PaulGrandperrin/nh-root/commit/bea0ce26e4b1a260e285164c49456d70d346c924.patch"; # don't bail when non-root
              hash = "sha256-w8/nfMkk/CeOaLW2XIUvKs7//bGm11Cj6ifyTYzlqjo=";
            })
          ];
      });
    };
  };
}
