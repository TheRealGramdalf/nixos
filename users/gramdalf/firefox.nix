{...}: {
  imports = [
    ./firefox/bitwarden.nix
    ./firefox/adblock.nix
    ./firefox/darkreader.nix
    ./firefox/privacy.nix
    ./firefox/hwaccel.nix
    ./firefox/general.nix
    ./sideberry.nix
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
        "datareporting.healthreport.uploadEnabled" = false;
        "toolkit.telemetry.enabled" = false;
        # Crash reports
        "breakpad.reportURL" = " ";
        "privacy.donottrackheader.enabled" = true;
        "privacy.donottrackheader" = "1";
        "privacy.firstparty.isolate" = true;
        "privacy.query_stripping" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.cryptomining.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.pbmode.enabled" = true;
        "privacy.usercontext.about_newtab_segregation.enabled" = true;
      };
    };
  };
}
