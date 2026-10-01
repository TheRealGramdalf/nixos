{pkgs, ...}: {
  tomeutils = {
    vapor = {
      enable = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
      extraPackages = [pkgs.gamescope];
    };
  };
  services.netbird.enable = true;

  users.users."root".openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEUC4zNha0aecrBoeptHPDsmfcwj6RopBNEpv6+NnzIM"];

  powerManagement.enable = true;

  programs.localsend.enable = true;
  environment.plasma6.excludePackages = [
    pkgs.kdePackages.konsole
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services = {
    colord.enable = true;
    # Disable orca since it's unneeded at the moment
    orca.enable = false;
  };
}
