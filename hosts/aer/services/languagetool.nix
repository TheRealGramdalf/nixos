{config, ...}: let
  name = "languagetool";
in {
  services.languagetool = {
    enable = true;
  };

  services.cone.extraFiles."${name}".settings = {
    http.routers."${name}" = {
      service = "${name}";
      rule = "Host(`${name}.aer.dedyn.io`)";
    };
    http.services."${name}".loadBalancer.servers = [{url = "http://127.0.0.1:${toString config.services.languagetool.port}";}];
  };
}
