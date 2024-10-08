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
            client_cns = ["aer"];
            listen = ":8888";
            type = "tls";
          };
          # zrepl/zrepl/issues/717
          recv.placeholder.encryption = "inherit";
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
