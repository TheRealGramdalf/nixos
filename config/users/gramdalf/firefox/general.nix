{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.firefox = {
    policies = {
      AppAutoUpdate = false;
      # DisableProfileRefresh #?
      ExtensionSettings = {
        # Remember to import the default config
        "{3c078156-979c-498b-8990-85f7987dd929}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sidebery/latest.xpi";
          installation_mode = "force_installed";
          default_area = "menupanel";
        };
        "Tab-Session-Manager@sienori" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/tab-session-manager/latest.xpi";
          installation_mode = "force_installed";
          default_area = "menupanel";
        };
      };
    };
  };
}
