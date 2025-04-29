{...}: let
  mimir = {
    name = "mimir";
    datadir = "/persist/services/mimir";
  };
  listenAddr = "127.0.0.1:12346";
in {
  services.mimir = {
    enable = true;
    configuration = {
      commom = {
        server = {
          grpc_listen_address = "127.0.0.1";
          http_listen_address = "127.0.0.1";
          #http_listen_port = 9009;
          log_level = "error";
        };
        multitenancy_enabled = false;

        blocks_storage = {
          backend = "filesystem";
          bucket_store.sync_dir = "/tmp/mimir/tsdb-sync";
          filesystem.dir = "/tmp/mimir/data/tsdb";
          tsdb.dir = "/tmp/mimir/tsdb";
        };

        ruler_storage = {
          backend = "filesystem";
          filesystem.dir = "/tmp/mimir/rules";
        };

        compactor = {
          data_dir = "/tmp/mimir/compactor";
          sharding_ring.kvstore.store = "memberlist";
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
  };

  # Proxy the alloy debug UI through traefik
  services.cone = {
    extraFiles = {
      "${alloy}".settings = {
        http.routers."${alloy}" = {
          rule = "Host(`${alloy}.aer.dedyn.io`)";
          service = "${alloy}";
          middlewares = "local-only";
        };
        http.services."${alloy}".loadbalancer.servers = [{url = "http://127.0.0.1:12346";}];
      };
    };
  };
}
