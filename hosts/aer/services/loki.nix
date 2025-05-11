{config, tome, ...}: let
  cfg = config.services.loki.configuration;
  loki = {
    uuid = "b1bf4973-4355-4f39-a675-905fb3641a34";
    name = "loki";
  };
in {
  services.loki = {
    enable = true;
    dataDir = "/persist/services/loki";
    # See https://grafana.com/docs/loki/latest/configure/
    configuration = {
      ui.enabled = true;
      server = {
        http_listen_address = "127.0.0.1";
        http_listen_port = 3100;
        proxy_protocol_enabled = true;
      };
      common.storage.filesystem = {
        chunks_directory = "/persist/services/loki/chunks";
        rules_directory = "/persist/services/loki/rules";
      };
    };
  };

  systemd.services = tome.mkUnixdService {
    nixosConfig = config;
    serviceName = "loki";
    extraServiceConfig = {
      User = loki.uuid;
      Group = loki.uuid;
    };
  };

  # Proxy loki through traefik for TLS
  services.cone = {
    extraFiles = {
      "${loki.name}".settings = {
        http.routers."${loki.name}" = {
          rule = "Host(`${loki.name}.aer.dedyn.io`)";
          service = "${loki.name}";
          middlewares = "local-only";
        };
        http.services."${loki.name}".loadbalancer.servers = [{url = "http://${cfg.server.http_listen_address}\:${toString cfg.server.http_listen_port}";}];
      };
    };
  };
}
