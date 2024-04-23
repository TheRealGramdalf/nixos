{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./firefox/bitwarden.nix
    ./firefox/adblock.nix
    ./firefox/darkreader.nix
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
    policies = {
      ExtensionSettings = {
        "{ce9f4b1f-24b8-4e9a-9051-b9e472b1b2f2}" = {
          # Clear browsing data
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/clear-browsing-data/latest.xpi";
          installation_mode = "force_installed";
          default_area = "menupanel";
        };
      };
    };
    profiles."gramdalf" = {
      isDefault = true;
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = false;
      };
      search.default = "DuckDuckGo";
      search.force = true;
    };
  };

  # https://stackoverflow.com/questions/53658303/fetchfromgithub-filter-down-and-use-as-environment-etc-file-source

  #home.file.".mozilla/firefox/gramdalf/chrome".source = pkgs.fetchFromGitHub {
  #  owner = "soulhotel";
  #  repo = "FF-ULTIMA";
  #  rev = "1.6.8";
  #  hash = "sha256-q+AyJF1cocyh2zWmp0VbLmduLbJqcfKQVbWlHUjCm5A=";
  #};
}
