_: let
  eno1 = "enp0s25"; # Double check this
in {
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
        gateway = ["10.0.0.1"];
        address = ["10.0.0.5/24"];
      };
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
    };
    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
    chrony.enable = true;
  };
}
