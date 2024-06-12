{
  hardware.enableRedistributableFirmware = true;

  # Enable 24.05 /etc overlay 
  #systemd.sysusers.enable = true;
  system.etc.overlay.enable = true;
  boot.initrd.systemd.enable = true;

  tomeutils = {
    vapor.enable = true;
    adhde.enable = true;
  };
}
