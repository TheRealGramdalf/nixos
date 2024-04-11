{ config, lib, modulesPath, pkgs, ... }: {
  boot = {
    zfs.devNodes = "/dev/disk/by-partlabel";
    plymouth.enable = true;
    tmp.cleanOnBoot = true;
    loader.systemd-boot.enable = true;
  };

  powerManagement = {
    enable = true;
    scsiLinkPolicy = "med_power_with_dipm";
  };
  
  system = {
    autoUpgrade = {
      enable = false;
      allowReboot = false;
      operation = "boot";
      dates = "daily";
      persistent = false;
    };
  };
  
  nix.settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
  };
  
  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    kanidm.enableClient = true;
    kanidm.clientSettings.uri = "https://auth.aer.dedyn.io";
    fwupd.enable = true;
  };  
  
  # Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "overlay2";
  programs.zsh.enable = true;
  programs.wireshark.enable = true;
  users = {
    mutableUsers = false;
    
    users."gramdalf" = {
      isNormalUser = true;
      description = "Gramdalf";
      extraGroups = [ "wheel" "networkmanager" "docker" "adbusers" "wireshark" ];
      hashedPasswordFile = "/persist/secrets/passwdfile.gramdalf";
      shell = pkgs.zsh;
    };
  };    
}
