{
  pkgs,
  lib,
  ...
}: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        # Avoid running hyprlock twice
        lock_cmd = "hyprctl dispatch exec 'pidof hyprlock || hyprlock'"; # Commands to run when `loginctl lock-session` is called
        #unlock_cmd = notify-send "unlock!"      # same as above, but unlock
        # Use this to debug sleep
        before_sleep_cmd = "hyprctl dispatch exec 'loginctl lock-session'";    # command ran before sleep
        #after_sleep_cmd = "";  # command ran after sleep
        ignore_dbus_inhibit = false;  # whether to ignore dbus-sent idle-inhibit requests (used by e.g. firefox or steam)
      };

      listener = [
        {timeout = 300; # in seconds
        on-timeout = "hyprctl dispatch exec 'loginctl lock-session'"; # command to run when timeout has passed
        on-resume = "";}# command to run when activity is detected after timeout has fired.
      ];
    };
  };
  systemd.user.services."hypridle".Service.Environment = ["PATH=$PATH:${lib.makeBinPath [pkgs.hyprland]}"];
}
