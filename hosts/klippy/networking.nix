_: {
  networking = {
    useNetworkd = true;
    useDHCP = false;
    # dhcpcd is far inferior to systemd-networkd
    dhcpcd.enable = false;
  };
  systemd.network = {
    enable = true;
    wait-online.enable = false;
    networks = {
      # Get a DHCP address
      "69-ether" = {
        # Match all non-virtual (veth) ethernet connections
        matchConfig = {
          Type = "ether";
          Kind = "!*";
        };
        linkConfig.RequiredForOnline = "no";
        networkConfig = {
          DHCP = true;
          MulticastDNS = "resolve";
          UseDomains = true;
        };
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
      settings."Resolve".MulticastDNS = "resolve";
    };
    avahi = {
      enable = true;
      nssmdns4 = false;
      nssmdns6 = false;
      openFirewall = true;
      allowInterfaces = ["eno1"];
    };
    chrony.enable = true;
  };
}
