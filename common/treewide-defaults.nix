{
  lib,
  config,
  pkgs,
  ...
}: {
  environment.sessionVariables = lib.optionalAttrs (config.services.netbird.enable) {
    NB_ADMIN_URL = "https://vpn.aer.dedyn.io";
    NB_MANAGEMENT_URL = "https://vpn.aer.dedyn.io";
  };

  environment.systemPackages = [pkgs.ghostty.terminfo];

  hardware.bluetooth.powerOnBoot = false;
  boot.tmp.cleanOnBoot = true;
  # Not needed (already default? might be stateversion)
  services.dbus.implementation = "broker";

  # The world must be oxidized
  security.sudo-rs.enable = true;
}
