{pkgs, ...}: {
  home = {
    username = "jhon";
    homeDirectory = "/home/jhon";
    stateVersion = "25.05";

    packages = with pkgs; [
      bitwarden
      picard # MusicBrainz Tagger
      vlc # VHS ripping and local media playback
      obs-studio # Recording for anything in general
      handbrake # For more manual ripping etc
      finamp # Music only from jellyfin
      jellyfin-media-player # Official client, for movies/tv shows
      spotify
      firefox
    ];
  };
}
