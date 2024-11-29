{
  home.file.".config/kscreenlockerrc" = {
    text = ''
      [Daemon]
      Autolock=true
      Timeout=0
    '';
    force = true;
  };
  home.file.".config/powerdevilrc" = {
    text = ''
      [AC][SuspendAndShutdown]
      InhibitLidActionWhenExternalMonitorPresent=false
      PowerButtonAction=1
      
      [Battery][SuspendAndShutdown]
      InhibitLidActionWhenExternalMonitorPresent=false
      PowerButtonAction=1
      
      [LowBattery][SuspendAndShutdown]
      InhibitLidActionWhenExternalMonitorPresent=false
      PowerButtonAction=1
    '';
    force = true;
  };
}