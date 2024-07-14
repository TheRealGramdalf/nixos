{
  config,
  lib,
  ...
}: let
  name = "vault";
  cfg = config.services.vaultwarden;
  dataDir = "/persist/services/vaultwarden";
in {
  services.vaultwarden = {
    enable = true;
    environmentFile = "/persist/secrets/vaultwarden/vaultwarden.env";
    config = {
      DATA_FOLDER = "${dataDir}";
      DOMAIN = "https://vault.aer.dedyn.io";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = "8222";
      SENDS_ALLOWED = true;
      LOGIN_RATELIMIT_MAX_BURST = 10;
      LOGIN_RATELIMIT_SECONDS = 60;
      ADMIN_RATELIMIT_MAX_BURST = 10;
      ADMIN_RATELIMIT_SECONDS = 60;
      EMERGENCY_ACCESS_ALLOWED = true;
      WEB_VAULT_ENABLED = true;
      SIGNUPS_ALLOWED = false;
      SIGNUPS_VERIFY = true;
      SIGNUPS_VERIFY_RESEND_TIME = 3600;
      SIGNUPS_VERIFY_RESEND_LIMIT = 5;
    };
  };
  systemd.services."vaultwarden" = {
    #after = [
    #  config.systemd.services."kanidm-unixd".name
    #  config.systemd.services."kanidm".name
    #  config.systemd.services."traefik".name
    #];
    #requires = [
    #  config.systemd.services."kanidm-unixd".name
    #  config.systemd.services."kanidm".name
    #  config.systemd.services."traefik".name
    #];
    serviceConfig = {
      User = lib.mkForce "5fa90349-b863-4d5e-b6c6-5a6f303fdb15";
      Group = lib.mkForce "5fa90349-b863-4d5e-b6c6-5a6f303fdb15";
      ReadWritePaths = ["${dataDir}"];
    };
  };

  services.cone.extraFiles."${name}".settings = {
    http.routers."${name}" = {
      service = "${name}";
      rule = "Host(`${name}.aer.dedyn.io`)";
    };
    http.services."${name}".loadBalancer.servers = [{url = "http://127.0.0.1:${cfg.config.ROCKET_PORT}";}];
  };
}
