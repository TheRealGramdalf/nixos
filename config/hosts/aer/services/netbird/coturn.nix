{config, lib, ...}: let
  cfg = config.services.netbird.server;
  cid = "netbird";
in {
  services.netbird.server = {
    management = {
      # These settings are advertised to clients, i.e. the outward facing ports
      turnPort = lib.mkForce 3478;
    };
    coturn = {
      enable = true;
      openPorts = [
        cfg.management.turnPort
      ];
      passwordFile = "/persist/secrets/netbird/coturn.pass";
    };
  };
  services.coturn = {
    listening-port = 3477;
    listening-ips = [
      "127.0.0.1"
      # the TURN server has to listen on this address for the udp port range
      "192.168.1.5"
    ];
    no-tcp = true;
    no-tcp-relay = true;
    no-tls = true;
    no-dtls = true;
  };

  services.cone.extraFiles = {
    "netbird-turn".settings = {
      udp.routers."netbird-turn" = {
        entrypoints = ["netbird-turn"];
        service = "netbird-turn";
      };
      udp.services."netbird-turn".loadbalancer.servers = [{address = "127.0.0.1:${toString config.services.coturn.listening-port}";}];
    };
  };
  services.cone.static.settings.entryPoints."netbird-turn" = {
    #http.tls.certResolver = "letsencrypt";
    address = ":3478/udp";
  };
}