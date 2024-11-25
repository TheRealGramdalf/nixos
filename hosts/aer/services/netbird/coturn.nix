{
  config,
  lib,
  ...
}: let
  cfg = config.services.netbird.server;
in {
  # For reference, see https://github.com/netbirdio/netbird/blob/main/infrastructure_files/turnserver.conf.tmpl
  # Of note, the tls-listening-port is enabled upstream
  services.netbird.server = {
    management = {
      # These settings are advertised to clients, i.e. the outward facing ports
      turnPort = lib.mkForce 3478;
      settings.TURNConfig.Turns = [
        {
          Proto = "udp";
          URI = "turn:${cfg.domain}:${toString cfg.management.turnPort}";
          Username = "netbird";
          Password =
            if (cfg.coturn.password != null)
            then cfg.coturn.password
            else {_secret = cfg.coturn.passwordFile;};
        }
      ];
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
    # This apparently needs to be direct; i.e. it can't be proxied through something unless
    # the port stays the same
    listening-port = 3478;
    alt-listening-port = 3476;
    listening-ips = [
      "127.0.0.1"
      # the TURN server has to listen on this address for the udp port range
      "192.168.1.5"
    ];
    relay-ips = [
      "192.168.1.5"
      "127.0.0.1"
    ];
    no-tcp = true;
    no-tcp-relay = true;
    no-tls = true;
    no-dtls = true;
    extraConfig = ''
      verbose = true
    '';
  };
}
