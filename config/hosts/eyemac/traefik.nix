{config, ...}: let
  cfg = config.services.cone;
in {
  services.cone = {
    enable = true;
    supplementaryGroups = ["docker"];
    dataDir = "/persist/services/traefik";
    dynamic.dir = "/persist/services/traefik/dynamic-config";
    environmentFiles = [
      "/persist/secrets/traefik/traefik.env"
    ];
    extraFiles = {
      "dashboard".settings = {
        http.routers."dashboard" = {
          service = "api@internal";
          rule = "Host(`traefik.${config.networking.hostName}.local`)";
        };
      };
    };
    static.settings = {
      log.level = "DEBUG";
      providers.docker = {
        defaultRule = "Host(`{{ index .Labels \"com.docker.compose.service\"}}.${config.networking.hostName}.local`)";
        watch = true;
      };
      global.checkNewVersion = false;
      serversTransport.insecureSkipVerify = true;
      api = {
        dashboard = true;
        disableDashboardAd = true;
        insecure = true;
      };
      entryPoints = {
        "web" = {
          address = ":80";
          http.redirections.entryPoint = {
            permanent = true;
            scheme = "https";
            to = "websecure";
          };
        };
        "websecure" = {
          address = ":443";
          asDefault = true;
          http.tls = {};
        };
      };
    };
  };
  networking.firewall = {
    allowedUDPPorts = [80 443];
    allowedTCPPorts = [80 443];
  };
}
