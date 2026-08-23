{
  inputs,
  config,
  ...
}: let
  env = config.services.mindwtr.cloud.environment;
  name = "mindwtr";
in {
  imports = [
    inputs.mindwtr-flake.nixosModules.default
  ];

  services.mindwtr.cloud = {
    enable = true;
    package = inputs.mindwtr-flake.packages.x86_64-linux."mindwtr-cloud";
    environment = {
      MINDWTR_CLOUD_DATA_DIR = "/persist/services/mindwtr";
      MINDWTR_CLOUD_AUTH_TOKENS_FILE = "/persist/secrets/mindwtr/tokens";
      MINDWTR_CLOUD_TRUST_PROXY_HEADERS = "true";
      MINDWTR_CLOUD_TRUSTED_PROXY_IPS = ["127.0.0.1"];
      MINDWTR_CLOUD_CORS_ORIGIN = "${name}.aer.dedyn.io";
      HOST = "127.0.0.1";
    };
  };

  services.traefik.routing.extraFiles."mindwtr-cloud".settings = {
    http.routers."${name}-cloud" = {
      rule = "Host(`cloud.${name}.aer.dedyn.io`)";
      service = "${name}-cloud";
      middlewares = "local-only";
    };
    http.services."${name}-cloud".loadbalancer.servers = [{url = "http://${env.HOST}:${env.PORT}";}];
  };
}
