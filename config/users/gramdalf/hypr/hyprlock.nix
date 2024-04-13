{
  config,
  pkgs,
  lib,
  ...
}: {
  home.file.".config/hypr/hyprlock.conf".source =
    pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "hyprlock";
      rev = "d5a6767000409334be8413f19bfd1cf5b6bb5cc6";
      hash = "sha256-pjMFPaonq3h3e9fvifCneZ8oxxb1sufFQd7hsFe6/i4=";
    }
    + "/hyprlock.conf";
}
