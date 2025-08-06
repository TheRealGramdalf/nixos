{pkgs, ...}: {
  tomeutils.vapor = {
    enable = true;
    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];
  };

  powerManagement.enable = true;

  # Enable KDE
  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = true;
  };
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole
  ];
  services.displayManager.sddm = {
    # SDDM isn't enabled by the plasma6 module
    enable = true;
    # Enable Wayland in SDDM so the system doesn't need X11
    wayland.enable = true;
    # Scale the display 2x
    settings.General = {
      GreeterEnvironment = "QT_SCREEN_SCALE_FACTORS=2,QT_FONT_DPI=192";
    };
  };

  networking = {
    # Required for KDE to control wifi via GUI
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
      dns = "systemd-resolved";
    };
    dhcpcd.enable = false;
    wireless.iwd.settings.Network = {
      # Integrate with systemd for e.g. mDNS
      NameResolvingService = "systemd";
      # Set the priority high to prefer ethernet when available
      RoutePriorityOffset = 300;
    };
  };
  # Disable NM's wait-online service. This delays boot significantly
  systemd.services."NetworkManager-wait-online".enable = false;
  services = {
    resolved = {
      llmnr = "false";
      enable = true;
      domains = ["local"];
      fallbackDns = [
        "1.1.1.1"
        "1.0.0.1"
      ];
      # Enable resolution only, leave responding to avahi
      extraConfig = ''
        [Resolve]
        MulticastDNS = resolve
      '';
    };
    # Printing, mDNS etc
    avahi = {
      enable = true;
      openFirewall = true;
      nssmdns4 = false;
      nssmdns6 = false;
    };
  };
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services = {
    colord.enable = true;
    # Disable orca since it's unneeded at the moment
    orca.enable = false;
    # Enable pulse emulation to get a GUI
    pipewire = {
      pulse.enable = true;
      alsa.enable = true;
    };
    # The actual printing control daemon
    printing = {
      enable = true;
      drivers = with pkgs; [gutenprint hplip splix];
    };
  };
}
