{config, ...}: {
  hardware = {
    nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
      # Currently (August 30th, 2024) refers to nvidia 550. Stable (560) currently has issues
      package = config.boot.kernelPackages.nvidiaPackages.production;
    };
  };

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
