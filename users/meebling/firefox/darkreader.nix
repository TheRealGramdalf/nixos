_: {
  # Make sure to load `dark-reader-settings.json` after first install, since there is (currently) no way of declarative configuration
  programs.firefox.policies = {
    ExtensionSettings."addon@darkreader.org" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
      installation_mode = "force_installed";
      default_area = "navbar";
    };
    # https://www.reddit.com/r/firefox/comments/o0xl1q/reducing_cpu_usage_of_dark_reader_extension/
    "nglayout.initialpaint.delay" = 250;
  };
}
