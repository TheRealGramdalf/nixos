{context, ...}: let
  domain = "aer.dedyn.io";
  port = 6941;
in {
  services.nginx = {
    enable = true;
    virtualHosts."${domain}" = {
      listen = [
        {
          addr = "127.0.0.1";
          inherit port;
        }
      ];
      locations = {
        "/" = {
          root = context.self.packages.x86_64-linux.dashy-ui.override {
            settings = {
              pageInfo = {
                title = "Aerwiar";
                description = "Launchpad for the Aerwiar home server";
              };
              appConfig = {
                preventWriteToDisk = true;
                disableUpdateChecks = true;
              };
            };
          };
          tryFiles = "$uri /index.html ";
        };
      };
    };
  };
  services.cone.extraFiles."dashy".settings = {
    http.routers."dashy" = {
      rule = "Host(`${domain}`)";
      service = "dashy";
      middlewares = "local-only";
    };
    http.services."dashy".loadbalancer.servers = [{url = "http://127.0.0.1:${toString port}";}];
  };
}
