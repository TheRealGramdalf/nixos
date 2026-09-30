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

  users.users."root".openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEUC4zNha0aecrBoeptHPDsmfcwj6RopBNEpv6+NnzIM"];

  powerManagement.enable = true;

  programs.localsend.enable = true;
  environment.plasma6.excludePackages = [
    pkgs.kdePackages.konsole
  ];

  networking = {
    # Required for KDE to control wifi via GUI
    networkmanager = {
      enable = true;
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
  };
}
