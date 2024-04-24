{
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
      # Ad-hoc user preferences, managed by policy
      Preferences = {
        privacy = {
          donottrackheader = {
            enabled = lock-true;
            value = 1;
            Status = "locked";
          };
          firstparty.isolate = lock-true;
          query_stripping = lock-true;
          trackingprotection = {
            cryptomining.enabled = lock-true;
            enabled = lock-true;
            fingerprinting.enabled = lock-true;
            pbmode.enabled = lock-true;
          };
          usercontext.about_newtab_segregation.enabled = lock-true;
        };
        network.http.speculative-parallel-limit = {
          Value = 0;
          Status = "locked";
        };
        browser.send_pings = lock-false;
        browser.places.speculativeConnect.enabled = lock-false;
        browser.urlbar.speculativeConnect.enabled = lock-false;
        network = {
          # DoH (Trusted Recursive Resolver)
          trr.mode = {
            Value = 5;
            Status = "locked";
          };
          prefetch-next = lock-false;
          predictor = {
            enabled = lock-false;
            enable-prefetch = lock-false;
          };
        };
        # Crash reports
        breakpad.reportURL = {
          Value = "";
          Status = "locked";
        };
        browser.startup.homepage_override.mstone = "ignore";
        # Not sure if these overlap
        extensions.getAddons.showPane = lock-false;
        extensions.htmlaboutaddons.recommendations.enabled = lock-false;
        datareporting.policy.dataSubmissionEnabled = lock-false;
        datareporting.healthreport.uploadEnabled = lock-false;
        toolkit.telemetry.enabled = lock-false;
      };
    };
  };
}
