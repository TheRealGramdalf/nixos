_: {
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
      # This interface might be good as a direct connection switch assuming it can be linked to a physical button
      #"14-recovery" = {
      #  # Ad-hoc recovery interface running a DHCP server
      #  name = "${eno4}";
      #  address = ["10.0.0.1/24"];
      #  networkConfig.DHCPServer = true;
      #};
      # Get a DHCP address on any connected interface
      "69-ether" = {
        # Match all non-virtual (veth) ethernet connections
        matchConfig = {
          Type = "ether";
          Kind = "!*";
        };
        networkConfig.DHCP = true;
      };
    };
  };
  services = {
    resolved = {
      llmnr = "false";
      enable = true;
      fallbackDns = [
        "1.1.1.1"
        "1.0.0.1"
      ];
      settings."Resolve".MulticastDNS = "resolve";
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
    chrony.enable = true;
  };
}
