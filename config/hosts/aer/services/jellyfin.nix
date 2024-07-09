_: let
  name = "media";
  port = "8920";
in {
  #    image = "lscr.io/linuxserver/jellyfin:10.8.13";
  systemd.services."jellyfin".environment = {
  };
  services.jellyfin = {
    enable = true;
    dataDir = "/tank/media";
    cacheDir = "/persist/services/jellyfin/cache";
    configDir = "/persist/services/jellyfin/config";
    user = "a08522ec-569d-41bb-ba65-635573489df1";
    group = "06761699-684d-46a5-bf75-500cf769977f";
    #SupplementaryGroups man systemd.exec
  };
  networking.firewall = {
    # from https://jellyfin.org/docs/general/networking/index.html
    allowedUDPPorts = [ 1900 7359 ]; # DLNA and client discovery respectively
  };

  services.cone.extraFiles."${name}".settings = {
    http.routers."${name}" = {
      service = "${name}";
      rule = "Host(`${name}.aer.dedyn.io`)";
    };
    http.services."${name}".loadBalancer.servers = [{url = "https://127.0.0.1:${port}";}];
  };
}
