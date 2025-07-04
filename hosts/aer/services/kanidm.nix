{
  config,
  pkgs,
  ...
}: let
  cfg = config.services.kanidm;
  dataDir = "/persist/services/kanidm";
in {
  #imports = [./kanisys.nix];
  # Temporary fix for nixpkgs#323674
  systemd.services."kanidm" = {
    #environment."KANIDM_DB_PATH" = "${dataDir}/db/kanidm.db";
    serviceConfig.BindPaths = [
      "${dataDir}"
      #"${dataDir}/db" # This is either technically a different filesystem, or getting borked by the path merge function, so it isn't mounted correctly by default
    ];
  };
  services.kanidm = {
    package = pkgs.kanidm_1_6;
    enableServer = true;
    enablePam = true;
    serverSettings = {
      version = "2";
      #log_level = "debug";
      origin = "https://auth.aer.dedyn.io";
      domain = "auth.aer.dedyn.io";
      # Needs https://github.com/NixOS/nixpkgs/pull/323676 to work properly
      #db_path = "${dataDir}/db/kanidm.db";
      db_fs_type = "zfs";
      tls_chain = "${dataDir}/chain.pem";
      tls_key = "${dataDir}/key.pem";
      bindaddress = "127.0.0.1:8443";
    };
    clientSettings.uri = cfg.serverSettings.origin;
    unixSettings = {
      pam_allowed_login_groups = ["3fd496d1-bdcb-42b3-bbab-040b6befcaac"];
      home_attr = "uuid";
      home_alias = "spn";
    };
  };

  networking.hosts = {
    "127.0.0.1" = [
      "${cfg.serverSettings.domain}"
    ];
  };

  services.cone.extraFiles."auth".settings = {
    http.routers."auth" = {
      service = "auth";
      rule = "Host(`${cfg.serverSettings.domain}`)";
    };
    http.services."auth".loadBalancer.servers = [{url = "https://${cfg.serverSettings.bindaddress}";}];
  };
}
