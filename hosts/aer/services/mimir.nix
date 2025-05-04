{
  config,
  tome,
  lib,
  ...
}: let
  mimir = {
    name = "mimir";
    dataDir = "/persist/services/mimir";
  };
  cfg = config.services.mimir.configuration;
in {
  services.mimir = {
    enable = true;
    configuration = {
      server = {
        # Enable settings for being behind a proxy
        proxy_protocol_enabled = true;
        log_source_ips_enabled = true;
        grpc_listen_address = "127.0.0.1";
        # 9095 is default, 9094 for behind proxy (potentially)
        grpc_listen_port = 9094;
        http_listen_address = "127.0.0.1";
        http_listen_port = 9009;
        log_level = "debug";
      };
      multitenancy_enabled = false;

      blocks_storage = {
        backend = "filesystem";
        bucket_store.sync_dir = "${mimir.dataDir}/tsdb-sync";
        filesystem.dir = "${mimir.dataDir}/data/tsdb";
        tsdb.dir = "${mimir.dataDir}/tsdb";
      };

      compactor = {
        # Not required to persist, done anyway for simplicity
        data_dir = "${mimir.dataDir}/compactor";
        sharding_ring.kvstore.store = "memberlist";
      };

      ruler_storage = {
        backend = "filesystem";
        filesystem.dir = "${mimir.dataDir}/rules";
      };

      distributor.ring = {
        instance_addr = "127.0.0.1";
        kvstore.store = "memberlist";
      };

      ingester.ring = {
        instance_addr = "127.0.0.1";
        kvstore.store = "memberlist";
        replication_factor = 1;
      };

      store_gateway.sharding_ring.replication_factor = 1;
    };
  };

  systemd.services = tome.mkUnixdService {
    nixosConfig = config;
    serviceName = "mimir";
    serviceUser = "15365d9a-2039-4c76-ac15-c4c4a3289a74";
    serviceGroup = "15365d9a-2039-4c76-ac15-c4c4a3289a74";
    extraServiceConfig = {
      DynamicUser = lib.mkForce false;
      WorkingDirectory = lib.mkForce mimir.dataDir;
    };
  };

  # Proxy mimir through traefik for TLS
  services.cone = {
    extraFiles = {
      "${mimir.name}".settings = {
        http.routers."${mimir.name}" = {
          rule = "Host(`${mimir.name}.aer.dedyn.io`)";
          service = "${mimir.name}";
          middlewares = "local-only";
        };
        http.services."${mimir.name}".loadbalancer.servers = [{url = "http://${cfg.server.http_listen_address}\:${toString cfg.server.http_listen_port}";}];
      };
    };
  };
}
