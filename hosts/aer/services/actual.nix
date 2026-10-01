{config, ...}: let
  dataDir = "/persist/services/actual";
  cfg = config.services.actual;
  name = "actual";
  client_id = "actual-server-aer_rs";
in {
  services.actual = {
    enable = true;
    settings = {
      port = 5006;
      hostname = "127.0.0.1";
      inherit dataDir;
      userFiles = "${dataDir}/user-files";
      serverFiles = "${dataDir}/server-files";
      loginMethod = "openid";
      enforceOpenId = true;
      allowedLoginMethods = ["openid"]; # Disable password authentication
      userCreationMode = "login";
      openId = {
        discoveryURL = "https://auth.${config.networking.fqdn}/oauth2/openid/${client_id}/.well-known/openid-configuration";
        inherit client_id;
        client_secret._secret = "/persist/secrets/actual/client_secret";
        server_hostname = "https://actual.${config.networking.fqdn}";
        authMethod = "openid"; # Enables full OIDC discovery
      };
      token_expiration = "3600"; # 1hr
    };
  };

  services.traefik.routing.extraFiles."${name}".settings = {
    http.routers."${name}" = {
      service = "${name}";
      rule = "Host(`${name}.${config.networking.fqdn}`)";
    };
    http.services."${name}".loadBalancer = {
      servers = [{url = "http://${cfg.settings.hostname}:${toString cfg.settings.port}";}];
      healthcheck.path = "/health";
    };
  };
}
