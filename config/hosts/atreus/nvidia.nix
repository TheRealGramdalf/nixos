{ config, lib, modulesPath, pkgs, ... }: {
  hardware = {    
    nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
    };
  };

  services = {
    thermald.enable = true;
    supergfxd.enable = true;
    asusd = {
      enable = true;
      enableUserService = true;
    };
    xserver.videoDrivers = [ "nvidia" ];    
  };
}
