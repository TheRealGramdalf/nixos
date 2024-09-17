_: let
  eno1 = "enp1s0f0";
  eno2 = "enp1s0f1";
  eno3 = "enp2s0f0";
  eno4 = "enp2s0f1";
in {
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
      "10-ingress" = {
        name = "${eno1}";
        gateway = ["192.168.1.1"];
        address = ["192.168.1.5/24"];
      };
      "14-recovery" = {
        # Ad-hoc recovery interface running a DHCP server
        name = "${eno4}";
        gateway = ["10.0.0.1"];
        address = ["10.0.0.1/24"];
        networkConfig.DHCPServer = true;
      };
      # If all else fails, get a DHCP address
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
      extraConfig = ''
        [Resolve]
        MulticastDNS = false
      '';
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      allowInterfaces = ["eno1"];
    };
    samba-wsdd = {
      enable = true;
      openFirewall = true;
      interface = "eno1";
    };
    chrony.enable = true;
  };
}
