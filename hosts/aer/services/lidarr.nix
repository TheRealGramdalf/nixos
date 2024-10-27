{
  config,
  pkgs,
  ...
}: let
  name = "lidarr";
  cfg = config.services.lidarr;
  arr_scripts = pkgs.fetchFromGitHub {
    owner = "RandomNinjaAtk";
    repo = "arr-scripts";
    rev = "f7c59f85192b771e16cc9f52aaf06289136ee0d7";
    fetchSubmodules = false;
    sha256 = "sha256-kUcmeeHoCHMQuRrtOrLPrpvpW0LmRf2smbzncQIIC9Y=";
  };
in {
  virtualisation.oci-containers.containers."lidarr" = {
    image = "lscr.io/linuxserver/lidarr:2.7.1";
    volumes = [
      "/persist/services/lidarr/config:/config"
      "/persist/services/lidarr/custom-services:/custom-services.d"
      # This needs `g+rwx` to work with the current group setup.
      "/tank/media:/tank/media"
      "${arr_scripts}/lidarr/scripts_init.bash:/custom-cont-init.d/scripts_init.bash:ro"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.services.lidarr.loadbalancer.server.port" = "8686";
      "traefik.http.routers.lidarr.service" = "lidarr";
      "traefik.http.routers.lidarr.middlewares" = "local-only@file";
      "hl.host" = "${name}";
    };
    extraOptions = [
      "--dns=1.1.1.1"
      "--dns-search=."
    ];
    environment = {
      PUID = "30200";
      PGID = "2003408767";
      TZ = config.time.timeZone;
    };
  };
}
