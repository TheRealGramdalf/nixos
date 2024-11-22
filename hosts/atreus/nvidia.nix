{config, ...}: {
  hardware = {
    nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
      # Currently (Nov. 21st, 2024) refers to nvidia 560
      package = config.boot.kernelPackages.nvidiaPackages.production;
    };
  };

  assertions = [
    {
      assertion = config.services.desktopManager.plasma6.enable == true;
      message = "KDE plasma is not enabled, remove the plasmoid package!";
    }
  ];
  environment.systemPackages = [pkgs.supergfxctl-plasmoid];
  services = {
    thermald.enable = true;
    supergfxd.enable = true;
    asusd = {
      enable = true;
      enableUserService = true;
    };
    xserver.videoDrivers = ["nvidia"];
  };
}
