{
  ...
}: {
  programs.firefox = {
    policies = {
      "3rdparty".Extensions."{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
        environment.base = "https://vault.aer.dedyn.io";
      };
      ExtensionSettings."{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        installation_mode = "force_installed";
        default_area = "navbar";
      };
      DisableFormHistory = true;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
    };
  };
}
