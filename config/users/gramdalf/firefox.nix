{
  config,
  lib,
  pkgs,
  ...
}:let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in {
  imports = [
    ./firefox/bitwarden.nix
    ./firefox/adblock.nix
    ./firefox/darkreader.nix
    ./firefox/sideberry.nix
    ./firefox/privacy.nix
    ./firefox/general.nix
  ];
  # For policy info, see:
  # - https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265/7
  # - https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265
  # - https://mozilla.github.io/policy-templates
  programs.firefox = {
    enable = true;
    profiles."gramdalf" = {
      isDefault = true;
      search.default = "DuckDuckGo";
      search.force = true;
      settings = {
        # These privacy settings can't be set via policy, so they need to be set here instead
        "datareporting.healthreport.uploadEnabled" = lock-false;
        "toolkit.telemetry.enabled" = lock-false;
        # Crash reports
        "breakpad.reportURL" = {
          Value = "";
          Status = "locked";
        };
        "privacy.donottrackheader.enabled" = lock-true;
        "privacy.donottrackheader" = {
          Value = 1;
          Status = "locked";
        };
        "privacy.firstparty.isolate" = lock-true;
        "privacy.query_stripping" = lock-true;
        "privacy.trackingprotection.enabled" = lock-true;
        "privacy.trackingprotection.cryptomining.enabled" = lock-true;
        "privacy.trackingprotection.fingerprinting.enabled" = lock-true;
        "privacy.trackingprotection.pbmode.enabled" = lock-true;
        "usercontext.about_newtab_segregation.enabled" = lock-true;
      };
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
