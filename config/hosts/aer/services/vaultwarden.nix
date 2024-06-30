{
  config,
  lib,
  ...
}: let
  name = "vault";
  cfg = config.services.vaultwarden;
in {
  services.vaultwarden = {
    enable = true;
    environmentFile = "/persist/secrets/vaultwarden.env";
    config = {
      DOMAIN = "https://vault.aer.dedyn.io";
      ROCKET_ADDRESS = "::1";
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
  systemd.services."vaultwarden".serviceConfig = {
    User = lib.mkForce "5fa90349-b863-4d5e-b6c6-5a6f303fdb15";
  };

  services.caddy.virtualHosts."${name}.aer.dedyn.io" = {
    listenAddresses = [
      "http://${cfg.config.ROCKET_ADDRESS}:${cfg.config.ROCKET_PORT}"
    ];
  };
}
