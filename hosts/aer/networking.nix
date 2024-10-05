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
        networkConfig.MulticastDNS = "resolve";
      };
      "14-recovery" = {
        # Ad-hoc recovery interface running a DHCP server
        name = "${eno4}";
        gateway = ["10.0.0.1"];
        address = ["10.0.0.1/24"];
        networkConfig = {
          DHCPServer = true;
          # Disable ipv6, see https://github.com/systemd/systemd/issues/5625#issuecomment-289372155
          LinkLocalAddressing = "no";
          IPv6AcceptRA = false;
          MulticastDNS = "resolve";
        };
        dhcpServerConfig = {
          ServerAddress = "10.0.0.1/24";
          EmitDNS = "yes";
          DNS = "10.0.0.1";
        };
        linkConfig.RequiredForOnline = "no";
      };
      # If all else fails, get a DHCP address
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
