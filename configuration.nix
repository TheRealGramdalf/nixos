{ config, lib, pkgs, ... }:

{
  imports = [];

  boot = {
    kernelModules = [ "kvm-intel" ];
    
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
    };

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "pool/root";
      fsType = "zfs";
    };
    
    "/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
    };
    
    "/nix" = {
      device = "pool/nix";
      fsType = "zfs";
    };
    
    "/home" = {
      device = "pool/home";
      fsType = "zfs";
    };
    
    "/safe" = {
      device = "pool/safe";
      fsType = "zfs";
    };
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;

    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
      ];
    };

    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
  };
  
  powerManagement = {
    enable = true;
    scsiLinkPolicy = "med_power_with_dipm";
  };

  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    config = {
      allowUnfree = true;
    };
  };

  system.stateVersion = "24.05";

  networking = {
    hostName = "mars-monkey-laptop";
    hostId = "8425e349";
    networkmanager.enable = true;
    nameservers = ["1.1.1.3" "1.0.0.3"];
    useDHCP = lib.mkDefault true;

    firewall = {
      enable = false;
      logRefusedConnections = true;
    };
 };

  time.timeZone = "Africa/Douala";
  i18n.defaultLocale = "en_CA.UTF-8";

  console = {
    font = "ter-v24b";
    useXkbConfig = true;
  };

  nix = {
    optimise = {
      automatic = true;
      dates = ["daily"];
    };
    
    gc = {
      automatic = true;
      persistent = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      trusted-users = ["@wheel"];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  programs = {
    hyprland.enable = true;
    waybar.enable = true;
    virt-manager.enable = true;
  };

  services = {
    printing.enable = true;
    fwupd.enable = true;
    thermald.enable = true;
    locate.enable = true;
    flatpak.enable = true;

    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;

    packages = with pkgs; [
      corefonts
      noto-fonts
    ];
    
    fontconfig.hinting = {
      enable = true;
      style = "full";
    };
  };

  security.rtkit.enable = true;

  users = {
    mutableUsers = false;
    
    users.mars-monkey = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "libvirtd" ];
      hashedPassword = "$y$j9T$PPMehWHX4aaQ5oMN3igBV0$zXYtqyL4ez7knABEGRMIYTPk1YERI/aY/qOaxXXq1q5";
      packages = with pkgs; [ home-manager ];
    };
  };

  environment = {
    systemPackages = with pkgs; [
      vim
      wget
      kitty
      gh
      git
      webcord
      librewolf
      xwaylandvideobridge
    ];
  };
}
