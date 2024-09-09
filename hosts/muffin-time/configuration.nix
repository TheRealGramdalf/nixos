{pkgs, ...}: {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
      };
    };
    zfs.devNodes = "/dev/disk/by-partlabel";
    plymouth = {
      enable = true;
      theme = "catppuccin-mocha";
      themePackages = [
        (pkgs.catppuccin-plymouth.override {variant = "mocha";})
      ];
    };
    tmp.cleanOnBoot = true;
  };
  environment.systemPackages = [pkgs.ntfs3g];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  users.mutableUsers = false;
  users.groups."muffin" = {};
  users.users."muffin" = {
    group = "muffin";
    isNormalUser = true;
    hashedPasswordFile = "/persist/secrets/muffin.psw"
  };

}
