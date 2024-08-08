_: let
  name = "media";
  port = "8096";
in {
  services.jellyfin = {
    enable = true;
    dataDir = "/persist/services/jellyfin/data";
    cacheDir = "/persist/services/jellyfin/cache";
    configDir = "/persist/services/jellyfin/config";
  };
  networking.firewall = {
    # from https://jellyfin.org/docs/general/networking/index.html
    allowedUDPPorts = [1900 7359]; # DLNA and client discovery respectively
  };

  services.cone.extraFiles."${name}".settings = {
    http.routers."${name}" = {
      service = "${name}";
      rule = "Host(`${name}.aer.dedyn.io`)";
    };
    http.services."${name}".loadBalancer.servers = [{url = "http://127.0.0.1:${port}";}];
  };
}
