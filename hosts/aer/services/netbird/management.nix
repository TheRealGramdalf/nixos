{config, ...}: let
  cfg = config.services.netbird.server;
  cid = "netbird";
  mgmtPort = "${toString cfg.management.port}";
in {
  services.netbird.server = {
    management = {
      port = 6969;
      extraOptions = [
        "--metrics-port=9091"
      ];
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
  };

  services.cone.extraFiles = {
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
}
