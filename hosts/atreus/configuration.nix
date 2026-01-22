{pkgs, ...}: {
  tomeutils = {
    vapor = {
      enable = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
      extraPackages = [pkgs.gamescope];
    };
  };
  services.netbird.enable = true;
  environment.sessionVariables = {
    NB_ADMIN_URL = "https://vpn.aer.dedyn.io";
    NB_MANAGEMENT_URL = "https://vpn.aer.dedyn.io";
  };

  users.users."root".openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEUC4zNha0aecrBoeptHPDsmfcwj6RopBNEpv6+NnzIM"];

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
      LLMNR = "false";
      enable = true;
      Domains = ["local"];
      FallbackDns = [
        "1.1.1.1"
        "1.0.0.1"
      ];
      # Enable resolution only, leave responding to avahi
      settings."Resolve".MulticastDNS = "resolve";
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
      alsa.enable = false;
    };
    # The actual printing control daemon
    printing = {
      enable = true;
      drivers = with pkgs; [gutenprint hplip splix brlaser];
    };
  };
}
