{config, ...}: let
  cfg = config.services.home-assistant;
  port = 8123;
  name = "home";
in {
  services.home-assistant = {
    enable = true;
    configDir = "/persist/services/home-assistant/config";
    #config = null;
    extraComponents = [
      # Storage acceleration
      "isal"
      # User defined
      # Sprinkler
      "rachio"
      # Washing machine
      "lg_thinq"
      # Tasmota smart devices
      "tasmota"
      "mqtt"
      # From the nixosmodule by default:
      "default_config"
      "esphome"
      "met"
    ];
    config = {
      default_config = {};
      homeassistant = {
        name = "Home";
        unit_system = "metric";
        temperature_unit = "C";
      };
      http = {
        base_url = "https://${name}.aer.dedyn.io";
        use_x_forwarded_for = true;
        trusted_proxies = [
          "127.0.0.1"
        ];
        server_host = ["127.0.0.1"];
      };
    };
  };
 
  # Proxy home-assistant through traefik
  services.cone.extraFiles."${name}".settings = {
    http.routers."${name}" = {
      rule = "Host(`${name}.aer.dedyn.io`)";
      service = "${name}";
      middlewares = "local-only";
    };
    http.services."${name}".loadbalancer.servers = [{url = "http://127.0.0.1:${toString port}";}];
  };
}
