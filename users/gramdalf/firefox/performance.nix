_: let
  lock-true = {
    Value = true;
    Status = "locked";
  };
in {
  programs.firefox.policies = {
    # Ad-hoc user preferences, managed by policy
    Preferences = {
      # Allow automatic unloading of tabs to help in OOM states
      "browser.tabs.unloadOnLowMemory" = lock-true;
    };
  };

  # Notes
  
  # - RAM usage: see `about:memory` to get a breakdown of what's using memory, including the breakdown of which extensions use what
  # - Hardware acceleration: see `about:support` to figure out which codecs are supported, what graphics cards are detected and so on
}