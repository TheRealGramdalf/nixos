{pkgs, inputs, ...}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.x86_64-linux;
in {
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      hidePodcasts
    ];
    theme = spicePkgs.themes.comfy;
  };
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
    ];
  };
}
