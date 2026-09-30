{
  pkgs,
  lib,
  ...
}: {
  # Firefox slightly more integrated (i.e. KDE Connect)
  programs.firefox.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services = {
    # Enable fingerprint reader
    fprintd.enable = false;
    # Control the malfunctioning fan
    thinkfan.enable = true;
  };
  specialisation."no-thinkfan".configuration = {
    services.thinkfan.enable = lib.mkForce false;
  };
}
