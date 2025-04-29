{tome, ...}: let
  alloy = "alloy";
  listenAddr = "127.0.0.1:12346";
in {
  services.alloy = {
    enable = false;
    extraFlags = [
  "--server.http.listen-addr=${listenAddr}"
  "--disable-reporting"
];
  };

  environment.etc."alloy/config.alloy".text = ''
  '';

  # Proxy the alloy debug UI through traefik
  services.cone = {
    extraFiles = {
      "${alloy}".settings = {
        http.routers."${alloy}" = {
          rule = "Host(`${alloy}.aer.dedyn.io`)";
          service = "${alloy}";
          middlewares = "local-only";
        };
        http.services."${alloy}".loadbalancer.servers = [{url = "http://${listenAddr}";}];
      };
    };
  };
}