{
  config,
  pkgs,
  lib,
  ...
}: {
  systemd.user.services."hypridle" = {
    Unit = {
      Description = "Hyprland's idle daemon";
      Documentation = "https://wiki.hyprland.org/Hypr-Ecosystem/hypridle";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
    Service = {
      Type = "simple";
      ExecStart = pkgs.lib.getExe pkgs.hypridle;
      Environment = [
        "PATH=$PATH:${lib.makeBinPath [pkgs.hyprland]}"
      ];
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
  home.file.".config/hypr/hypridle.conf".text = ''
    general {
        lock_cmd = hyprctl dispatch exec 'hyprlock & systemctl suspend'          # dbus/sysd lock command (loginctl lock-session)
        #unlock_cmd = notify-send "unlock!"      # same as above, but unlock
        #before_sleep_cmd = notify-send "Zzz"    # command ran before sleep
        #after_sleep_cmd = notify-send "Awake!"  # command ran after sleep
        ignore_dbus_inhibit = false             # whether to ignore dbus-sent idle-inhibit requests (used by e.g. firefox or steam)
    }

    listener {
        timeout = 500                            # in seconds
        on-timeout = notify-send "You are idle!" # command to run when timeout has passed
        on-resume = notify-send "Welcome back!"  # command to run when activity is detected after timeout has fired.
    }
  '';
}
