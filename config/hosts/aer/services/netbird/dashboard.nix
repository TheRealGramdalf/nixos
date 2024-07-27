{config, ...}: let
  cfg = config.services.netbird.server;
  cid = "netbird";
in {
  services.netbird.server = {
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
  };
}
