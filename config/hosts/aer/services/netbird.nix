{config, ...}: let
  cfg = config.services.netbird.server;
  cid = "netbird";
  sigPort = "${toString cfg.signal.port}";
  mgmtPort = "${toString cfg.management.port}";
in {
  services.netbird.server = {
    # This top level switch enables some defaults based on top level options
    enable = true;
    domain = "vpn.aer.dedyn.io";
    management = {
      port = 6969;
      logLevel = "DEBUG";
      disableAnonymousMetrics = true;
      disableSingleAccountMode = true;
      oidcConfigEndpoint = "https://auth.aer.dedyn.io/oauth2/openid/${cid}/.well-known/openid-configuration";
      settings = {
        HttpConfig.AuthAudience = cid;
        TURNConfig.Secret = {_secret = "/persist/secrets/netbird/turn-secret";};
        # Generate this with `wg genkey`
        DataStoreEncryptionKey = {_secret = "/persist/secrets/netbird/datastore.key";};
      };
    };
    dashboard = {
      enable = true;
      enableNginx = true;
      settings = {
        AUTH_AUDIENCE = cid;
        AUTH_CLIENT_ID = cid;
        AUTH_AUTHORITY = "https://auth.aer.dedyn.io/oauth2/openid/${cid}";
        AUTH_SUPPORTED_SCOPES = "openid profile email offline_access api";
      };
    };
    signal = {
      port = 6968;
      logLevel = "DEBUG";
    };
    coturn = {
      enable = true;
      passwordFile = "/persist/secrets/netbird/coturn.pass";
    };
  };
  services.nginx.virtualHosts.${cfg.domain}.listen = [
    {
      port = 6942;
      addr = "127.0.0.1";
    }
  ];

  services.cone.extraFiles = {
    "netbird-dash".settings = {
      http.routers."netbird-dash" = {
        rule = "Host(`${cfg.domain}`)";
        service = "netbird-dash";
      };
      http.services."netbird-dash".loadbalancer.servers = [{url = "http://127.0.0.1:6942";}];
    };
    "netbird-signal".settings = {
      http.routers."netbird-signal" = {
        rule = "Host(`${cfg.domain}`) && PathPrefix(`/signalexchange.SignalExchange/`)";
        service = "netbird-signal";
      };
      http.services."netbird-signal".loadbalancer.servers = [{url = "h2c://127.0.0.1:${sigPort}";}];
    };
    "netbird-mgmt".settings = {
      http.routers."netbird-mgmt" = {
        rule = "Host(`${cfg.domain}`) && PathPrefix(`/api`)";
        service = "netbird-mgmt";
      };
      http.services."netbird-mgmt".loadbalancer.servers = [{url = "http://127.0.0.1:${mgmtPort}";}];
      http.routers."netbird-api" = {
        rule = "Host(`${cfg.domain}`) && PathPrefix(`/management.ManagementService/`)";
        service = "netbird-api";
      };
      http.services."netbird-api".loadbalancer.servers = [{url = "h2c://127.0.0.1:${mgmtPort}";}];
    };
  };
  services.cone.static.settings.entryPoints."3478" = {
    http.tls.certResolver = "letsencrypt";
    address = ":3478/udp";
  };
  networking.firewall = {
    allowedUDPPorts = [3478]; # turn: port
    #allowedUDPPortRanges = [{from = 49152; to = 65535;}];
  };
}
