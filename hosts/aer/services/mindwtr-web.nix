{
  inputs,
  config,
  ...
}: let
  port = 6940;
in {
  services.mindwtr.web = {
    enable = true;
    package = inputs.mindwtr-flake.packages.x86_64-linux."mindwtr-web";
    nginx = {
      virtualHost = "mindwtr.aer.dedyn.io";
      listen = [
        {
          addr = "127.0.0.1";
          inherit port;
        }
      ];
    };
  };

  # Proxy nginx through traefik
  services.traefik.routing.extraFiles."mindwtr-web".settings = {
    http.routers."mindwtr-web" = {
      rule = "Host(`${config.services.mindwtr.web.nginx.virtualHost}`)";
      service = "mindwtr-web";
      middlewares = "local-only";
    };
    http.services."mindwtr-web".loadbalancer.servers = [{url = "http://127.0.0.1:${toString port}";}];
  };
}
