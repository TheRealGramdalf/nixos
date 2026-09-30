{pkgs, ...}: {
  tomeutils.vapor = {
    enable = true;
    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];
    extraPackages = [pkgs.gamescope];
  };

  powerManagement.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole
  ];
  services.displayManager.sddm = {
    # Scale the display 2x
    settings.General = {
      GreeterEnvironment = "QT_SCREEN_SCALE_FACTORS=2,QT_FONT_DPI=192";
    };
  };

  networking = {
    networkmanager = {
      dns = "systemd-resolved";
    };
    dhcpcd.enable = false;
  };
  services = {
    resolved = {
      enable = true;
      settings."Resolve" = {
        LLMNR = "false";
        Domains = ["local"];
        FallbackDns = [
          "1.1.1.1"
          "1.0.0.1"
        ];
        # Enable resolution only, leave responding to avahi
        MulticastDNS = "resolve";
      };
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
  };
}
