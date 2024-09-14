{
  # Enable KDE
  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = true;
  };
  services.displayManager.sddm = {
    # SDDM isn't enabled by the plasma6 module
    enable = true;
    # Enable Wayland in SDDM so the system doesn't need X11
    wayland.enable = true;
  };

  networking = {
    # Required for KDE to control wifi via GUI
    networkmanager.enable = true;
  };
  
  # Firefox slightly more integrated (i.e. KDE Connect)
  programs.firefox.enable = true;

  services = {
    # Enable fingerprint reader
    fprintd.enable = true;
    # Control the malfunctioning fan
    thinkfan = {
      enable = true;
      # See https://www.desmos.com/calculator/ldzn6pj5pl
      # for a visualization of the fan curve. The meaning
      # can be found at https://www.mankier.com/5/thinkfan.conf.legacy
      levels = [
        [
          0
          0
          50
        ]
        [
          1
          48
          60
        ]
        [
          2
          50
          61
        ]
        [
          3
          52
          63
        ]
        [
          6
          56
          65
        ]
        [
          7
          60
          32767
        ]
      ];
    };
  };
}