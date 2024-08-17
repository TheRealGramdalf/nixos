{config, pkgs, ...}: let
  name = "lidarr";
  cfg = config.services.lidarr;
  arr_scripts = pkgs.fetchFromGitHub {
    owner = "RandomNinjaAtk";
    repo = "arr-scripts";
    rev = "8d9271f31d8282a3c7bbfc1eea008d631b5ce70e";
    fetchSubmodules = false;
    sha256 = "sha256-kUcmeeHoCHMQuRrtOrLPrpvpW0LmRf2smbzncQIIC9Y=";
  };
in {
  virtualisation.oci-containers.containers."lidarr" = {
    image = "lscr.io/linuxserver/lidarr:2.4.3";
    volumes = [
      "/persist/services/lidarr/config:/config"
      "/persist/services/lidarr/custom-services:/custom-services.d"
      "/tank/media:/data/media"
      "${arr_scripts}/lidarr/scripts_init.bash:/custom-cont-init.d/scripts_init.bash:ro"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.services.lidarr.loadbalancer.server.port" = "8686";
      "traefik.http.routers.lidarr.service" = "lidarr";
      "traefik.http.routers.lidarr.middlewares" = "local-only@file";
      "hl.host" = "${name}";
    };
    environment = {
      PUID = "30200";
      PGID = "60100";
      TZ = config.time.timeZone;
    };
  };
}
