{
  ...
}: {
  imports = [
    ./firefox/bitwarden.nix
    ./firefox/adblock.nix
    ./firefox/darkreader.nix
    ./firefox/sideberry.nix
    ./firefox/telemetry.nix
    ./firefox/privacy.nix
    ./firefox/general.nix
  ];
  # For policy info, see:
  # - https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265/7
  # - https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265
  # - https://mozilla.github.io/policy-templates
  programs.firefox = {
    enable = true;
    profiles."games" = {
      isDefault = true;
      search.default = "DuckDuckGo";
      search.force = true;
    };
  };
}
