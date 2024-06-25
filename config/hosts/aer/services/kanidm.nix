{config, ...}:
let
  cfg = config.services.kanidm;
  name = "kanidm";
in {
  services.kanidm = {
    enableServer = true;
    enablePam = true;
    serverSettings = {
      log_level = "DEBUG";
      origin = "https://auth.aer.dedyn.io";
      domain = "auth.aer.dedyn.io";
      db_path = "/persist/services/kanidm/kanidm.db";
      bindaddress = "127.0.0.1:8443";
    };
    clientSettings.uri = cfg.serverSettings.origin;
  };

  services.traefik.dynamicConfigOptions = {
    http.routers.${name} = {
      rule = "Host(`${cfg.serverSettings.domain}`)";
      service = ${name};
    };
    http.services.${name}.loadbalancer.servers = [
      {url = "${cfg.serverSettings.bindaddress}";}
    ];
  };
}