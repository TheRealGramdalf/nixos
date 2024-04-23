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
        "treestyletab@piro.sakura.ne.jp" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/tree-style-tab/latest.xpi";
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
