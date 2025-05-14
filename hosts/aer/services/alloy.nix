{
  tome,
  config,
  ...
}: let
  alloy = "alloy";
  listenAddr = "127.0.0.1:12346";
in {
  services.alloy = {
    enable = true;
    extraFlags = [
      "--server.http.listen-addr=${listenAddr}"
      "--disable-reporting"
    ];
  };

  # For reference, see https://grafana.com/docs/alloy/latest/collect/
  environment.etc."alloy/config.alloy".text = ''
    prometheus.exporter.self "metamonitor" {
    }
    prometheus.scrape "metamonitoring" {
      targets    = prometheus.exporter.self.metamonitor.targets
      forward_to = [prometheus.remote_write.mimir.receiver]
    }
    prometheus.remote_write "mimir" {
      endpoint {
        url = "https://mimir.aer.dedyn.io/api/v1/push"
      }
    }
  '';

  # Many thanks to
  # https://www.claudiokuenzler.com/blog/1462/how-to-scrape-node-exporter-metrics-grafana-alloy
  # and
  # https://www.claudiokuenzler.com/blog/1474/how-to-retrieve-metrics-all-processes-grafana-alloy
  # See https://grafana.com/docs/alloy/latest/reference/components/prometheus/prometheus.exporter.unix
  # for node_exporter reference
  environment.etc."alloy/unix.alloy".text = ''
    prometheus.exporter.unix "localhost" {
      include_exporter_metrics = true
      enable_collectors = [
        "systemd",
        "processes",
      ]
    }
    prometheus.scrape "node" {
      targets    = prometheus.exporter.unix.localhost.targets
      forward_to = [prometheus.remote_write.mimir.receiver]
    }
  '';

  environment.etc."alloy/journal.alloy".text = ''
    loki.source.journal "syslog" {
      forward_to    = [loki.write.logging.receiver]
    }
    loki.write "logging" {
      endpoint {
        url = "https://loki.aer.dedyn.io/loki/api/v1/push"
      }
    }
  '';

  systemd.services."alloy".serviceConfig = {
    ReadWritePaths = [
      "/run/dbus/system_bus_socket"
    ];
    SupplementaryGroups = [
      "adm"
      "systemd-journal"
    ];
  };

  # Proxy the alloy debug UI (?) through traefik
  services.cone = {
    extraFiles = {
      "${alloy}".settings = {
        http.routers."${alloy}" = {
          rule = "Host(`${alloy}.aer.dedyn.io`)";
          service = "${alloy}";
          middlewares = "local-only";
        };
        http.services."${alloy}".loadbalancer.servers = [{url = "http://${listenAddr}";}];
      };
    };
  };
}
