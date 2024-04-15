{
  config,
  pkgs,
  ...
}: {
  home.file."~/.config/hypr/hypridle.conf".text = lib.toHyprconf {
    general = {
      lock_cmd = "notify-send 'lock!'";          # dbus/sysd lock command (loginctl lock-session)
      unlock_cmd = "notify-send 'unlock!'";      # same as above, but unlock
      before_sleep_cmd = "notify-send 'Zzz'";    # command ran before sleep
      after_sleep_cmd = "notify-send 'Awake!'";  # command ran after sleep
      ignore_dbus_inhibit = false;             # whether to ignore dbus-sent idle-inhibit requests (used by e.g. firefox or steam)
    };

    listener {
      timeout = 500;                            # in seconds
      on-timeout = "notify-send 'You are idle!'"; # command to run when timeout has passed
      on-resume = "notify-send 'Welcome back!'";  # command to run when activity is detected after timeout has fired.
    };
  }
}
