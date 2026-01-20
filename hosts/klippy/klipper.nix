_: {
  services.klipper = {
    enable = true;
    mutableConfig = true;
    configDir = "/persist/services/klipper";
    configFile = "/persist/services/klipper/printer.cfg";
  };
  services.mainsail = {
    enable = false;
  };

  security.polkit.enable = true;
  services.moonraker = {
    enable = true;
    allowSystemControl = true;
    configDir = "/persist/services/moonraker/config";
    stateDir = "/persist/services/moonraker";
  };
}