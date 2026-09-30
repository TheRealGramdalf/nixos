{lib, config, ... }: {
  environment.sessionVariables = lib.optionalAttrs (config.services.netbird.enable) {
    NB_ADMIN_URL = "https://vpn.aer.dedyn.io";
    NB_MANAGEMENT_URL = "https://vpn.aer.dedyn.io";
  };
}