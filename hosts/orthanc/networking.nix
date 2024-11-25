_: {
  services.netbird.enable = true;
  environment.sessionVariables = {
    NB_ADMIN_URL = "https://vpn.aer.dedyn.io";
    NB_MANAGEMENT_URL = "https://vpn.aer.dedyn.io";
  };
  networking = {
    useNetworkd = true;
    useDHCP = false;
    # dhcpcd is far inferior to systemd-networkd
    dhcpcd.enable = false;
  };
  systemd.network = {
    enable = true;
    # wait-online might be useful if a single interface can be used
    wait-online.enable = false;
    networks = {
      # If all else fails, get a DHCP address
      "69-ether" = {
        # Match all non-virtual (veth) ethernet connections
        matchConfig = {
          Type = "ether";
          Kind = "!*";
        };
        networkConfig = {
          DHCP = true;
          MulticastDNS = "resolve";
          Domains = ["local"];
        };
        routes = [
          {
            # ip route add
            # default
            Destination = "0.0.0.0/0";
            Scope = "global";
            # via *
            Gateway = "_dhcp4";
            # `dev *` is covered by the network match section
          }
        ];
      };
    };
  };
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
    avahi = {
      enable = true;
      nssmdns4 = false;
      nssmdns6 = false;
      openFirewall = true;
      publish = {
        enable = true;
        addresses = true;
      };
    };
    chrony.enable = true;
  };
}
