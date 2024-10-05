_: {
  services.zrepl = {
    enable = true;
    settings = {
      jobs = [
        {
          name = "offsite-backup";
          connect = {
            ca = "/persist/secrets/zrepl/orthanc.crt";
            cert = "/persist/secrets/zrepl/aer.crt";
            key = "/persist/secrets/zrepl/aer.key";
            server_cn = "orthanc";
            address = "orthanc:8888";
            type = "tls";
          };
          filesystems = {
            "tank/smb<" = true;
            "tank/media<" = true;
            "medusa/services<" = true;
            "aer-zroot/safe/persist<" = true;
          };
          pruning = {
            keep_receiver = [
              {
                grid = "1x1h(keep=all) | 24x1h | 30x1d | 6x30d";
                # Only prune zrepl created snapshots
                regex = "^zrepl_";
                type = "grid";
              }
            ];
            keep_sender = [
              {type = "not_replicated";}
              {
                count = 10;
                type = "last_n";
              }
            ];
          };
          snapshotting = {
            interval = "10m";
            prefix = "zrepl_";
            type = "periodic";
          };
          type = "push";
        }
      ];
    };
  };
}
