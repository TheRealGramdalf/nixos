{ config, lib, modulesPath, pkgs, ... }: {
  imports = [  ];
  boot = {
    zfs.devNodes = "/dev/disk/by-partlabel";
    plymouth.enable = true;
    tmp.cleanOnBoot = true;
    loader.systemd-boot.enable = true;
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
      ];
    };
  };
  
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
    fwupd.enable = true;
    locate.enable = true;
    flatpak.enable = true;
    printing.enable = true;
    gvfs.enable = true;
    gnome = {
      gnome-keyring.enable = true;
      core-utilities.enable = false;
    };
    
    xserver = {
      enable = true;
      xkb.layout = "us";
      # libinput.enable = true;
      excludePackages = [ pkgs.xterm ];
      
      desktopManager = {
        gnome.enable = true;
        xterm.enable = false;
      };

      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };
    
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
  
  environment = {
    systemPackages = with pkgs; [ ];
    gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome.gnome-shell-extensions
    ];
  };
}
