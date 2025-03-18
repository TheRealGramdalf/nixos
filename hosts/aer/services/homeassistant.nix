{config, ...}: let
  cfg = config.services.home-assistant;
  name = "home";
in {
  services.home-assistant = {
    enable = true;
    configDir = "/persist/services/home-assistant/config";
    config = null;
    #config = {
    #  default_config = {};
    #  homeassistant = {
    #    name = "Home";
    #    unit_system = "metric";
    #    temperature_unit = "C";
    #  };
    #  http = {
    #    use_x_forwarded_for = true;
    #    trusted_proxies = [
    #      "127.0.0.1"
    #    ];
    #    server_host = ["127.0.0.1"];
    #  };
    #};
  };
 
  # Proxy home-assistant through traefik
  services.cone.extraFiles."${name}".settings = {
    http.routers."${name}" = {
      rule = "Host(`${name}.aer.dedyn.io`)";
      service = "${name}";
      middlewares = "local-only";
    };
    http.services."${name}".loadbalancer.servers = [{url = "http://127.0.0.1:${toString cfg.config.http.server_port}";}];
  };
}
