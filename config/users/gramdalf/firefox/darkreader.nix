{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.firefox = {
    policies = {
      "3rdparty".Extensions."addon@darkreader.org" = {
        detectDarkTheme = true;
        previewNewDesign = true;
        fetchNews = false;
        disabledFor = [
          "*.aer.dedyn.io"
        ];
      };
      ExtensionSettings."addon@darkreader.org" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
        installation_mode = "force_installed";
        default_area = "navbar";
      };
    };
  };
}