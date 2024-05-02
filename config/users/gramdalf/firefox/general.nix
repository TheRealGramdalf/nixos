{...}: {
  programs.firefox.policies = {
    AppAutoUpdate = false;
    # DisableProfileRefresh #?
    ExtensionSettings = {
      # Remember to import the default config
      "Tab-Session-Manager@sienori" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/tab-session-manager/latest.xpi";
        installation_mode = "force_installed";
        default_area = "menupanel";
      };
    };
  };
}
