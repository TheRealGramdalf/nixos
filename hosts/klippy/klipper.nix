{config, ...}: {
  services.klipper = {
    enable = true;
    user = "moonraker";
    group = "moonraker";
    mutableConfig = true;
    configDir = "/persist/services/klipper/config";
    configFile = "/persist/services/klipper/config/printer.cfg";
    firmwares."anycubic-i3-mega" = {
      # Don't bother compiling this unless needed
      enable = true;
      serial = "/dev/serial/by-id/usb-Silicon_Labs_CP2102_USB_to_UART_Bridge_Controller_0001-if00-port0";
      enableKlipperFlash = true;
      configFile = ./firmware-config;
    };
  };
  services.mainsail = {
    enable = true;
    nginx.extraConfig = ''
      client_max_body_size 2G;
    '';
  };
  networking.firewall = {
    allowedTCPPorts = [80 config.services.moonraker.port];
  };

  security.polkit.enable = true;
  services.moonraker = {
    enable = true;
    allowSystemControl = true;
    stateDir = "/persist/services/klipper";
    settings = {
      file_manager.enable_object_processing = true;
      server.max_upload_size = 2048;
      authorization = {
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
          "*://*.local"
          "*://*.lan"
          "*://${config.networking.hostName}"
        ];
      };
      # Required for orca-slicer to upload prints
      octoprint_compat = {};
    };
  };

  # Auto restart klipper when the printer is connected via usb
  # Credit https://github.com/Klipper3d/klipper/issues/835#issuecomment-441186301
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", ACTION=="add", RUN+="/bin/sh -c 'echo FIRMWARE_RESTART > ${config.services.klipper.inputTTY}'"
  '';
  # curl --unix-socket comms/moonraker.sock http://localhost/ -d '{"jsonrpc":"2.0","method":"printer.firmware_restart","id":8463}␃' --http0.9
}
