_: {
  services.klipper = {
    enable = true;
    mutableConfig = true;
    configDir = "/persist/services/klipper"
  };
  services.mainsail = {
    enable = true;
  };
  services.moonraker = {
    enable = true;
    allowSystemControl = true;
    configDir = "/persist/services/moonraker/config";
    stateDir = "/persist/services/moonraker"
  }
}