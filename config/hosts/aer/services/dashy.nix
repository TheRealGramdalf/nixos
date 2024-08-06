{context, ...}: let
  domain = "aer.dedyn.io";
  port = 6941;
  settings = {};
in {
  #virtualisation.oci-containers."dash" = {
  #  image = "lissy93/dashy:3.1.1";
  #  environment = {
  #    NODE_ENV = "production";
  #    SSL_PRIV_KEY_PATH = "/etc/secrets/dashy.key";
  #    SSL_PUB_KEY_PATH = "/etc/secrets/dashy.pub";
  #    SSL_PORT = 8443;
  #    UID = 30300;
  #    GID = 30300; # dashy-aer@auth.aer.dedyn.io
  #  };
  #  labels = {
  #    "traefik.enable" = true;
  #    "traefik.http.services.dash.loadbalancer.server.scheme" = "https";
  #    "traefik.http.services.dash.loadbalancer.server.port" = 8443;
  #    "traefik.http.routers.dash.middlewares" = "local-only@file";
  #    "traefik.http.routers.dash.rule" = "Host(`aer.dedyn.io`)";
  #  };
  #};
  services.nginx = {
    enable = true;
    virtualHosts."${domain}" = {
      listen = [
        {
          addr = "127.0.0.1";
          inherit port;
          #proxyProtocol = true;
        }
      ];
      locations = {
        "/" = {
          root = context.self.packages.x86_64-linux.dashy-ui.override {inherit settings;};
          tryFiles = "$uri /index.html "; #$uri.html =404
        };

        #"/404.html".extraConfig = ''
        #  internal;
        #'';
      };

      #extraConfig = ''
      #  error_page 404 /404.html;
      #'';
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
