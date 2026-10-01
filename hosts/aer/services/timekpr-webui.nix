{
  inputs,
  lib,
  config,
  ...
}: let
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
    wantedBy = ["multi-user.target"];
    wants = ["network-online.target"];
    after = ["network-online.target"];
    serviceConfig = {
      User = user;
      Group = group;
      WorkingDirectory = stateDir;
      ExecStart = "${lib.getExe inputs.self.packages.x86_64-linux.timekpr-webui}";
    };
  };

  services.traefik.routing.extraFiles."timekpr".settings = {
    http.routers."timekpr" = {
      rule = "Host(`timekeeper.${config.networking.fqdn}`)";
      service = "timekpr";
      middlewares = "local-only";
    };
    http.services."timekpr".loadbalancer.servers = [{url = "http://127.0.0.1:5000";}];
  };
}
