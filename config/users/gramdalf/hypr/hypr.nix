{pkgs, ...}: {
  imports = [
    ./waybar.nix
    ./hyprpaper.nix
  ];
  tomeutils.hyprkeys.workspaces.scratchpad.enable = true;
  services.cliphist.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      source = [
        "~/.config/hypr/mocha.conf"
      ];
      # UserPreferences
      "$fileManager" = "nautilus";
      "$menu" = "anyrun";
      monitor = [
        # name,resolution,position,scale

        # Built-in display
        "eDP-2, 2560x1600@165, 0x0, 1.6, vrr,1"

        # Fallback for plugging in random monitors
        ",highres, auto, auto"
      ];
      xwayland.force_zero_scaling = true;
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0; # -1.0 to 1.0, 0 means no modification.
        accel_profile = "flat";
        touchpad = {
          natural_scroll = true;
          clickfinger_behavior = true;
          tap-to-click = false; # What's palm rejection?
        };
      };
      gestures = {
        workspace_swipe = true;
      };
      windowrulev2 = [
        "suppressevent maximize, class:.*" # You'll probably like this.
        "float, move onscreen 50% 50%, class:io.github.kaii_lb.Overskride" # Make overskride/iwgtk a popup window, move out later
        "float, move onscreen 50% 50%, class:org.twosheds.iwgtk"
        "float, move onscreen 50% 50%, class:iwgtk" # For the password prompt
        # Add title: Extension: (Bitwarden - Free Password Manager) - Bitwarden — Mozilla Firefox
        "bordercolor $red,xwayland:1" # Set the bordercolor to red if window is Xwayland
      ];
      # Binds
      bind = [
        "$mainMod, SPACE, exec, $menu"
        "$mainMod, return, exec, [float;tile] wezterm start --always-new-process"
        "$mainMod, C, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, V, togglefloating,"
        "$mainMod, P, pseudo," #dwindle
        "$mainMod, J, togglesplit," #dwindle

        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        ", Print SHIFT, exec, grimblast copysave output"
      ];
      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };
      decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        rounding = 10;
        blur = {
          enabled = true;
          size = 2;
          passes = 1;
        };
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "$surface1";
        "col.shadow_inactive" = "$surface1";
      };
      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      master.new_is_master = true;
      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      dwindle = {
        pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # you probably want this
      };
      general = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        gaps_in = 5;
        gaps_out = "10, 15, 10, 15";
        border_size = 2;
        "col.active_border" = "$mauve";
        "col.inactive_border" = "$surface0";
        layout = "dwindle";
        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;
      };
      env = [
        "QT_QPA_PLATFORMTHEME,qt5ct" # change to qt6ct if you have that
      ];
    };
  };
  home.file.".config/hypr/mocha.conf".source =
    pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "hyprland";
      rev = "v1.3";
      hash = "sha256-jkk021LLjCLpWOaInzO4Klg6UOR4Sh5IcKdUxIn7Dis=";
    }
    + "/themes/mocha.conf";
}
