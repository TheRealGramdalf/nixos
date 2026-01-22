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
  networking.firewall = {
    allowedTCPPorts = [80];
  };

  security.polkit.enable = true;
  services.moonraker = {
    enable = true;
    allowSystemControl = true;
    configDir = "/persist/services/moonraker/config";
    stateDir = "/persist/services/moonraker";
    settings.authorization = {
      trusted_clients = [
        "10.0.0.0/8"
        "127.0.0.0/8"
        "169.254.0.0/16"
        "172.16.0.0/12"
        "192.168.0.0/16"
        "FE80::/10"
        "::1/128"
      ];
      cors_domains = [
        "http://*.local"
        "http://*.lan"
      ];
    };
  };
}
