{ pkgs, ... }: {
  hardware.openrazer = {
    enable = true;
    users = [
      "meebling"
      "meeblingthedevilish"
    ];
  };
  environment.systemPackages = [
    pkgs.razergenie
  ];
}