{ config, lib, modulesPath, pkgs, ... }: {
  hardware = {    
    nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
    };

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
      ];
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
