{
  config,
  lib,
  ...
}: let
  cfg = config.services.actual;
  name = "actual";
  client_id = "actual-server-aer_rs";
in {
  services.actual = {
    enable = true;
    settings = {
      hostname = "127.0.0.1";
      dataDir = "/persist/services/actual";
      loginMethod = "openid";
      openId = {
        discoveryURL = "https://auth.aer.dedyn.io/oauth2/openid/${client_id}/.well-known/openid-configuration";
        client_id = client_id;
        client_secret._secret = "/persist/secrets/actual/client_secret";
        server_hostname = "https://actual.aer.dedyn.io";
        authMethod = "openid"; # Enables full OIDC discovery
        enforce = true; # Use OIDC only
      };
      token_expiration = "3600"; # 1hr
    };
  };

  services.cone.extraFiles."${name}".settings = {
    http.routers."${name}" = {
      service = "${name}";
      rule = "Host(`${name}.aer.dedyn.io`)";
    };
    http.services."${name}".loadBalancer.servers = [{url = "http://${cfg.settings.hostname}\:${cfg.settings.port}";}];
  };
}
