{config, ...}: let
  name = "media";
  port = "8096";
in {
  systemd.services."jellyfin" = {
    after = [
      config.systemd.services."kanidm-unixd".name
    ];
    requires = [
      config.systemd.services."kanidm-unixd".name
    ];
  };
  services.jellyfin = {
    enable = true;
    dataDir = "/persist/services/jellyfin/data";
    cacheDir = "/persist/services/jellyfin/cache";
    configDir = "/persist/services/jellyfin/config";
    user = "a08522ec-569d-41bb-ba65-635573489df1";
    group = "06761699-684d-46a5-bf75-500cf769977f";
    #SupplementaryGroups man systemd.exec
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
