_: {
  services.zrepl = {
    enable = true;
    settings = {
      jobs = [
        {
          name = "aer-offsite-backup";
          type = "sink";
          root_fs = "isengard/sink";
          serve = {
            ca = "/persist/secrets/zrepl/aer.crt";
            cert = "/persist/secrets/zrepl/orthanc.crt";
            key = "/persist/secrets/zrepl/orthanc.key";
            server_cn = "aer";
            listen = ":8888";
            type = "tls";
          };
        }
      ];
    };
  };
  networking.firewall = {
    allowedTCPPorts = [
      8888
    ];
  };
}
