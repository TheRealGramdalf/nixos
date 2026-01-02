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
      port = 5006;
      hostname = "127.0.0.1";
      dataDir = "/persist/services/actual";
      userFiles = "${cfg.settings.dataDir}/user-files";
      serverFiles = "${cfg.settings.dataDir}/server-files";
      loginMethod = "openid";
      enforceOpenId = true;
      allowedLoginMethods = ["openid"]; # Disable password authentication
      userCreationMode = "login";
      openId = {
        discoveryURL = "https://auth.aer.dedyn.io/oauth2/openid/${client_id}/.well-known/openid-configuration";
        client_id = client_id;
        client_secret._secret = "/persist/secrets/actual/client_secret";
        server_hostname = "https://actual.aer.dedyn.io";
        authMethod = "openid"; # Enables full OIDC discovery
      };
      token_expiration = "3600"; # 1hr
    };
  };

  services.cone.extraFiles."${name}".settings = {
    http.routers."${name}" = {
      service = "${name}";
      rule = "Host(`${name}.aer.dedyn.io`)";
    };
    http.services."${name}".loadBalancer.servers = [{url = "http://${cfg.settings.hostname}\:${toString cfg.settings.port}";}];
  };
}
