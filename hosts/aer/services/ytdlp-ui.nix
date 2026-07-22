{
  config,
  pkgs,
  ...
}: let
  name = "ytdlp";
  srvPath = "/persist/services/ytdlp";
in {
  virtualisation.oci-containers.containers."ytdlp-ui" = {
    user = "30550:60100"; # ytdlp-aer:media-aer
    image = "marcobaobao/yt-dlp-webui:latest";
    command = [
      "--auth"
      "--user=admin"
      "--pass=supersecretpassword"
      #"--out=/data/media/music/.ingest/ytdlp"
    ];
    volumes = [
      "/tank/media/music/.ingest/ytdlp:/downloads"
      "${srvPath}/config:/config" # optional
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.services.ytdlp.loadbalancer.server.port" = "3033";
      "traefik.http.routers.ytdlp.middlewares" = "local-only@file";
      "hl.host" = "${name}";
    };
    extraOptions = [
      "--dns=1.1.1.1"
      "--dns-search=."
    ];
    environment = {
      TZ = config.time.timeZone;
      XDG_CONFIG_HOME = "/config";
      JWT_SECRET = "randomsecret";
    };
  };
}
# https://github.com/yt-dlp/yt-dlp#plugins
# https://discord.com/channels/807245652072857610/807247901981016094/1197745216157909012
# --extractor-args "youtube:chapters_file=/config/chapters.ch"
# yt-dlp \
#   -o "chapter:%(fulltitle)s/%(section_number)s - %(section_title)s.%(ext)s" \
#   --extractor-args "youtube:chapters_file=/config/chapters.ch" \
#   -x --split-chapters --embed-metadata \
#   https://www.youtube.com/watch?v=61ankz8_8ug \
#   -sv

