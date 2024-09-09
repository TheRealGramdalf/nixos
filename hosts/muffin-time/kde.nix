{
  # Enable KDE
  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = true;
  };
  
  # Firefox slightly more integrated (i.e. KDE Connect)
  programs.firefox.enable = true;

  services = {
    # Enable fingerprint reader
    fprintd.enable = true;
    # Control the malfunctioning fan
    thinkfan.enable = true;
  };
}