{config, ...}: let
  cfg = config.services.home-assistant;
  ha = "home";
  ha-port = 8123;
  mq = "mqtt";
  mq-port = 1883;
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
        base_url = "https://${ha}.aer.dedyn.io";
        use_x_forwarded_for = true;
        trusted_proxies = [
          "127.0.0.1"
        ];
        server_host = ["127.0.0.1"];
      };
    };
  };

  services.mosquitto = {
    enable = true;
    dataDir = "/persist/services/mosquitto";
    listeners = [
      # Proxied through traefik
      {
        port = mq-port;
        address = "127.0.0.1";
        users = {
          "root" = {
            acl = ["readwrite #"];
            passwordFile = "/persist/secrets/mosquitto/root.passwdfile";
          };
          "IoT" = {
            acl = [ "readwrite homeassistant/#" ];
            passwordFile = "/persist/secrets/mosquitto/IoT.passwdfile";
          };
        };
      }
    ];
  };

  # Proxy home-assistant and MQTT through traefik
  services.cone = {
    extraFiles = {
    "${ha}".settings = {
      http.routers."${ha}" = {
        rule = "Host(`${ha}.aer.dedyn.io`)";
        service = "${ha}";
        middlewares = "local-only";
      };
      http.services."${ha}".loadbalancer.servers = [{url = "http://127.0.0.1:${toString ha-port}";}];
    };
    "${mq}".settings = {
      http.routers."${mq}" = {
        rule = "Host(`${mq}.aer.dedyn.io`)";
        service = "${mq}";
        middlewares = "local-only";
      };
      http.services."${mq}".loadbalancer.servers = [{url = "http://127.0.0.1:${toString mq-port}";}];
    };
    };
  };
}
