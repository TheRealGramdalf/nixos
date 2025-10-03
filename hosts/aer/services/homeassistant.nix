{
  config,
  pkgs,
  ...
}: let
  cfg = config.services.home-assistant;
  ha = "home";
  ha-port = 8123;
  mq = "mqtt";
  mq-port = 1883;
in {
  services.home-assistant = {
    enable = true;
    configDir = "/persist/services/home-assistant/config";
    customComponents = [
      pkgs.home-assistant-custom-components.auth_oidc
    ];
    extraComponents = [
      # Storage acceleration
      "isal"
      # User defined
      # Sprinkler
      # The controller advertises itself as
      # a homekit device
      "rachio"
      "homekit_controller"
      # Washing machine
      "lg_thinq"
      # Heat pump/furnace
      "econet"
      # Tasmota smart devices
      "tasmota"
      "mqtt"
      # tp-link Kasa smart home
      "tplink"
      # Printing
      "ipp"
      "brother"
      # Vacuum
      "roomba"
      # Time, for sunrise alarm
      "time_date"
      # So the logs stop spamming errors
      "google_translate"
      # From the nixosmodule by default:
      "default_config"
      "esphome"
      "met"
    ];
    config = {
      auth_oidc = {
        client_id = "home-assistant-aer_rs";
        discovery_url = "https://auth.aer.dedyn.io/oauth2/openid/home-assistant-aer_rs/.well-known/openid-configuration";
        id_token_signing_alg = "ES256";
        features.include_groups_scope = true;
        roles.admin = "15cdd9ec-08d0-4ca0-930f-5b9631c5ccb0";
        claims.groups = "groups";
        # TODO
        # For modifying the frontend, see
        # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/servers/home-assistant/frontend.nix
        # https://github.com/home-assistant/frontend/pull/23204
        # https://github.com/christiaangoossens/hass-oidc-auth/blob/main/CONTRIBUTING.md#better-user-experience
      };
      # Include automations, scenes, and scripts,
      # these are part of a writable yaml file
      "automation ui" = "!include automations.yaml";
      "scene ui" = "!include scenes.yaml";
      "script ui" = "!include scripts.yaml";
      default_config = {};
      homeassistant = {
        name = "Home";
        internal_url = "https://${ha}.aer.dedyn.io";
        external_url = "https://${ha}.aer.dedyn.io";
        unit_system = "metric";
        temperature_unit = "C";
      };
      http = {
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
          "iot-devices" = {
            acl = ["readwrite #"];
            passwordFile = "/persist/secrets/mosquitto/iot-devices.passwdfile";
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
        tcp.routers."${mq}" = {
          rule = "HostSNI(`${mq}.aer.dedyn.io`)";
          tls = true;
          service = "${mq}";
          middlewares = "local-only";
          entryPoints = ["mqtt"];
        };
        tcp.services."${mq}".loadbalancer.servers = [{address = "127.0.0.1:${toString mq-port}";}];
      };
    };
  };
}
