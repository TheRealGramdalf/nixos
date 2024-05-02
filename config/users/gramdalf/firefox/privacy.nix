{...}: let
  lock-false = {Value = false;Status = "locked";};
in {
  programs.firefox.policies = {
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
    DisableFirefoxStudies = true;
    DisablePocket = true;
    DisableTelemetry = true;
    UserMessaging = {
      WhatsNew = true;
      ExtensionRecommendations = false;
      FeatureRecommendations = false;
      UrlbarInterventions = false;
      SkipOnboarding = true;
      MoreFromMozilla = false;
      Locked = true;
    };
    # Ad-hoc user preferences, managed by policy
    Preferences = {
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
      "browser.startup.homepage_override.mstone" = "ignore";
      # Not sure if these overlap
      "extensions.getAddons.showPane" = lock-false;
      "extensions.htmlaboutaddons.recommendations.enabled" = lock-false;
      "datareporting.policy.dataSubmissionEnabled" = lock-false;
    };
  };
}
