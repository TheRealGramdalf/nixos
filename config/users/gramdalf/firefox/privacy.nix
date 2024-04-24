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
  programs.firefox = {
    policies = {
      SearchSuggestEnabled = false;
      FirefoxHome = {
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
        Locked = false;
      };
      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
        Locked = true;
      };
      DisableFirefoxStudies = lock-true;
      DisablePocket = lock-true;
      DisableTelemetry = lock-true;
      UserMessaging = {
        WhatsNew = true;
        ExtensionRecommendations = lock-false;
        FeatureRecommendations = lock-false;
        UrlbarInterventions = lock-false;
        SkipOnboarding = lock-true;
        MoreFromMozilla = lock-false;
      };
      # Ad-hoc user preferences, managed by policy
      Preferences = {
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
        "network.http.speculative-parallel-limit" = {
          Value = 0;
          Status = "locked";
        };
        "browser.send_pings" = lock-false;
        "browser.places.speculativeConnect.enabled" = lock-false;
        "browser.urlbar.speculativeConnect.enabled" = lock-false;
        # DoH (Trusted Recursive Resolver)
        "network.trr.mode" = {
          Value = 5;
          Status = "locked";
        };
        "network.prefetch-next" = lock-false;
        "network.predictor.enabled" = lock-false;
        "network.predictor.enable-prefetch" = lock-false;
        # Crash reports
        "breakpad.reportURL" = {
          Value = "";
          Status = "locked";
        };
        "browser.startup.homepage_override.mstone" = "ignore";
        # Not sure if these overlap
        "extensions.getAddons.showPane" = lock-false;
        "extensions.htmlaboutaddons.recommendations.enabled" = lock-false;
        "datareporting.policy.dataSubmissionEnabled" = lock-false;
        "datareporting.healthreport.uploadEnabled" = lock-false;
        "toolkit.telemetry.enabled" = lock-false;
      };
    };
  };
}
