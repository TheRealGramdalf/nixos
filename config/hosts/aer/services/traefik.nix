{config, ...}: let
  cfg = config.services.traefik;
in {
  services.cone = {
    enable = true;
    extraFiles."dashboard".settings = {
      traefik.http.routers."api".service = "api@internal";
      traefik.http.services."api".loadbalancer.server.port = 8080;
    };
    # Traefik's user/group must be local, since it's required for `kanidm-unixd` to function properly
    dataDir = "/persist/services/traefik";
    dynamic.dir = "/run/traefik/dynamic-config";
    static.settings = {
      log.level = "DEBUG";
      providers.docker = {
        defaultRule = "Host(`{{ index .Labels \"com.docker.compose.service\"}}.aer.dedyn.io`)";
        network = "proxynet";
        watch = true;
      };
      global.checkNewVersion = false;
      serversTransport.insecureSkipVerify = true;
      api = {
        dashboard = true;
        disableDashboardAd = true;
        insecure = true;
      };
      certificatesResolvers = {
        "letsencrypt".acme = {
          caServer = "https://acme-v02.api.letsencrypt.org/directory";
          dnsChallenge = {
            delayBeforeCheck = "30s";
            disablePropagationCheck = true;
            provider = "desec";
          };
          email = "gramdalftech@gmail.com";
          storage = "${cfg.dataDir}/certs/letsencrypt.json";
        };
        "letsencrypt-staging".acme = {
          caServer = "https://acme-staging-v02.api.letsencrypt.org/directory";
          dnsChallenge = {
            delayBeforeCheck = "30s";
            disablePropagationCheck = true;
            provider = "desec";
          };
          email = "gramdalftech@gmail.com";
          storage = "${cfg.dataDir}/certs/letsencrypt-staging.json";
        };
        "zerossl".acme = {
          caServer = "https://acme.zerossl.com/v2/DV90";
          dnsChallenge = {
            delayBeforeCheck = "30s";
            disablePropagationCheck = true;
            provider = "desec";
          };
          eab = {
            hmacEncoded = "hmac";
            kid = "kid";
          };
          email = "gramdalftech@gmail.com";
          storage = "${cfg.dataDir}/traefik/certs/zerossl.json";
        };
      };
      entryPoints = {
        "traefik" = {
          address = ":8080";
        };
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
          http.tls = {
            certResolver = "letsencrypt";
            domains = [
              {
                main = "aer.dedyn.io";
                sans = ["*.aer.dedyn.io"];
              }
            ];
          };
        };
      };
    };
  };
  networking.firewall = {
    allowedUDPPorts = [80 443];
    allowedTCPPorts = [80 443];
  };
}
