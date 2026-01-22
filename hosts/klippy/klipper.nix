_: {
  services.klipper = {
    enable = true;
    mutableConfig = true;
    configDir = "/persist/services/klipper";
    configFile = "/persist/services/klipper/printer.cfg";
    firmwares."anycubic-i3-mega" = {
      serial = "/dev/serial/by-id/usb-Silicon_Labs_CP2102_USB_to_UART_Bridge_Controller_0001-if00-port0";
      enableKlipperFlash = true;
      configFile = "/persist/services/klipper/firmware-config";
    };
  };
  services.mainsail = {
    enable = true;
  };

  security.polkit.enable = true;
  services.moonraker = {
    enable = true;
    allowSystemControl = true;
    configDir = "/persist/services/moonraker/config";
    stateDir = "/persist/services/moonraker";
  };
}