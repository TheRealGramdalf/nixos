{pkgs, ...}: {
  hardware = {
    ckb-next.enable = true;
    opentabletdriver.enable = true;
    openrazer = {
      enable = true;
      users = [
        "meebling"
        "meeblingthedevilish"
      ];
    }
  };
  environment.systemPackages = [
    pkgs.polychromatic
  ];
}
