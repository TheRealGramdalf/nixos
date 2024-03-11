{ config, lib, modulesPath, pkgs, ... }: {
  hardware = {
    # Pulse needs to be disabled (pipewire is used instead)
    pulseaudio.enable = false;
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
    # Opengl doesn't seem to be enabled by the gnome module
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
      ];
    };
  };
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
    locate.enable = true;
    flatpak.enable = true;
    printing.enable = true;
    gnome = {
      gnome-keyring.enable = true;
      core-utilities.enable = false;
    };
    
    xserver = {      
      desktopManager = {
        gnome.enable = true;
        xterm.enable = false;
      };

      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
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
