{
  inputs,
  lib,
  ...
}: let
  cfg = {
    name = "mindwtr";
    user = "mindwtr";
    group = "mindwtr";
    port = 8787;
    host = "127.0.0.1";
    package = inputs.self.outputs.packages.x86_64-linux.mindwtr-cloud;
    dataDir = "/persist/services/mindwtr";
    tokensFile = "/persist/secrets/mindwtr/tokens";
  };
in {
  systemd.services.mindwtr = {
    description = "Mindwtr cloud server";
    wants = ["network-online.target"];
    after = ["network-online.target"];
    wantedBy = ["multi-user.target"];
    startLimitIntervalSec = 86400;
    startLimitBurst = 5;
    environment = {
      MINDWTR_CLOUD_DATA_DIR = cfg.dataDir;
      MINDWTR_CLOUD_AUTH_TOKENS_FILE = cfg.tokensFile;
      MINDWTR_CLOUD_TRUST_PROXY_HEADERS = "true";
      MINDWTR_CLOUD_TRUSTED_PROXY_IPS = "127.0.0.1";
      MINDWTR_CLOUD_CORS_ORIGIN = "${cfg.name}.aer.dedyn.io";
    };
    serviceConfig = {
      ExecStart = "${lib.getExe cfg.package} -- --port ${toString cfg.port} --host ${cfg.host}";
      Type = "simple";
      User = cfg.user;
      Group = cfg.group;
      Restart = "on-failure";
      NoNewPrivileges = true;
      LimitNPROC = 64;
      LimitNOFILE = 1048576;
      PrivateTmp = true;
      PrivateDevices = true;
      ProtectHome = true;
      ProtectSystem = "full";
      ReadWritePaths = [
        cfg.dataDir
      ];
      ReadOnlyPaths = cfg.tokensFile;
      #RuntimeDirectory = "mindwtr";
    };
  };

  users.users = {
    "${cfg.user}" = {
      group = cfg.group;
      isSystemUser = true;
    };
  };
  users.groups = {
    "${cfg.group}" = {};
  };

  services.cone.extraFiles."mindwtr-cloud".settings = {
    http.routers."${cfg.name}" = {
      rule = "Host(`${cfg.name}.aer.dedyn.io`)";
      service = "${cfg.name}";
      middlewares = "local-only";
    };
    http.services."${cfg.name}".loadbalancer.servers = [{url = "http://${cfg.host}:${toString cfg.port}";}];
  };
}
