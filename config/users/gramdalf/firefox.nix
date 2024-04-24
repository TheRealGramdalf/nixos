{
  config,
  lib,
  pkgs,
  ...
}: let
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
}
