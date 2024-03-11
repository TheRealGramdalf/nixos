{ config, lib, modulesPath, pkgs, ... }: {
  imports = [  ];
  boot = {
    zfs.devNodes = "/dev/disk/by-partlabel";
    plymouth.enable = true;
    tmp.cleanOnBoot = true;
    loader.systemd-boot.enable = true;
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
      ];
    };
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
  
  console = {
    font = "ter-v24b";
    keyMap = "us";
  };
  
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;
  
  i18n.defaultLocale = "en_US.UTF-8";
#  time.timeZone = "America/Vancouver";

  networking = {
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    nameservers = [ "1.1.1.3" "1.0.0.3" ];
    
    firewall = {
      enable = true;
      logRefusedConnections = true;
    };
  };
  services = {
    kanidm.clientSettings.uri = "https://auth.aer.dedyn.io";    
    xserver = {
      enable = true;
      xkb.layout = "us";
      # libinput.enable = true;
      excludePackages = [ pkgs.xterm ];
    };
    
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
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
      
      packages = with pkgs; [
        home-manager
        git
        neovim
        nerdfonts
        wget
        curl
     ];
    };
  };    
}
