{config, tome, lib, ...}: let
  cfg = config.services.loki.configuration;
  loki = {
    uuid = "b1bf4973-4355-4f39-a675-905fb3641a34";
    name = "loki";
    dataDir = config.services.loki.dataDir;
  };
in {
  services.loki = {
    enable = true;
    dataDir = "/persist/services/loki";
    # See https://grafana.com/docs/loki/latest/configure/
    configuration = {
      analytics.reporting_enabled = false;
      #ui.enabled = true;
      auth_enabled = false;
      server = {
        http_listen_address = "127.0.0.1";
        http_listen_port = 3100;
        proxy_protocol_enabled = true;
      };
      common = {
        path_prefix = config.services.loki.dataDir;
        storage.filesystem = {
          chunks_directory = "${loki.dataDir}/chunks";
          rules_directory = "${loki.dataDir}/rules";
        };
        replication_factor = 1;
        ring.kvstore.store = "inmemory";
        ring.instance_addr = "127.0.0.1";
      };

      

      #ingester.chunk_encoding = "snappy";

      #limits_config = {
      #  retention_period = "120h";
      #  ingestion_burst_size_mb = 16;
      #  reject_old_samples = true;
      #  reject_old_samples_max_age = "12h";
      #};

      #table_manager = {
      #  retention_deletes_enabled = true;
      #  retention_period = "120h";
      #};

      #compactor = {
      #  retention_enabled = true;
      #  compaction_interval = "10m";
      #  working_directory = "${config.services.loki.dataDir}/compactor";
      #  delete_request_cancel_period = "10m"; # don't wait 24h before processing the delete_request
      #  retention_delete_delay = "2h";
      #  retention_delete_worker_count = 150;
      #  delete_request_store = "filesystem";
      #};

      schema_config.configs = [
        {
          from = "2025-01-01";
          store = "tsdb";
          object_store = "filesystem";
          schema = "v13";
          index.prefix = "index_";
          index.period = "24h";
        }
      ];

      ruler = {
        storage = {
          type = "local";
          local.directory = "${loki.dataDir}/ruler";
        };
        rule_path = "${loki.dataDir}/rules";
        #alertmanager_url = "http://alertmanager.r";
      };

      #query_range.cache_results = true;
      #limits_config.split_queries_by_interval = "24h";
    };
  };

  systemd.services = tome.mkUnixdService {
    nixosConfig = config;
    serviceName = "loki";
    extraServiceConfig = {
      User = lib.mkForce loki.uuid;
      Group = lib.mkForce loki.uuid;
    };
  };

  users.users."loki".enable = false;
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
