{inputs, lib, ...}: let 
  user = "timekpr-webui";
  group = user;
  stateDir = "/persist/services/timekpr-webui/";
in {
  users = {
    users."${user}" = {
      isSystemUser = true;
      inherit group;
    };
    groups."${group}" = {};
  };

  systemd.services."timekpr-webui" = {
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      User = cfg.user;
      Group = cfg.group;
      WorkingDirectory = stateDir;
      ExecStart = "${lib.getExe inputs.self.packages.x86_64-linux.timekpr-webui}";
    };
  };

    services.cone.extraFiles."timekpr".settings = {
    http.routers."timekpr" = {
      rule = "Host(`timekeeper.aer.dedyn.io`)";
      service = "timekpr";
      middlewares = "local-only";
    };
    http.services."timekpr".loadbalancer.servers = [{url = "http://127.0.0.1:5000";}];
  };
}
