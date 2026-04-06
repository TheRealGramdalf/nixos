{
  home.file.".config/kscreenlockerrc" = {
    text = ''
      [Daemon]
      LockGrace=0
      Timeout=5
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
