{config, ...}: let
  name = "cockpit";
  cfg = config.services.cockpit;
in {
  services.cockpit = {
    enable = true;
    settings = {
      WebService = {
        #Origins = ""; 
        ProtocolHeader = "X-Forwarded-Proto";
        ForwardedForHeader = "X-Forwarded-For";
        LoginTo = false;
      };
    };
  };
  services.cone.extraFiles."${name}".settings = {
    http.routers."${name}" = {
      service = "${name}";
      rule = "Host(`${name}.aer.dedyn.io`)";
      middlewares = "local-only";
    };
    http.services."${name}".loadBalancer.servers = [{url = "http://127.0.0.1:${cfg.port}";}];
  };
}