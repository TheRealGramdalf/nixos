{pkgs, ...}: {
  imports = [
    ./waybar.nix
  ];
  home.packages = with pkgs; [
    playerctl
    grimblast
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      source = [
        "~/.config/hypr/mocha.conf"
      ];
      # UserPreferences
      "$terminal" = "kitty";
      "$fileManager" = "nautilus";
      "$menu" = "anyrun";
      # Bind prefs
      "$mainMod" = "SUPER";

      monitor = [
        # name,resolution,position,scale

        # TV
        #"eDP-2, 2560x1600@165, 0x0, 1.6, vrr,1"

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

        "float,class:org.wezfurlong.wezterm"
      ];
      # Binds
      bind = [
        "$mainMod, SPACE, exec, $menu"
        "$mainMod, Q, exec, $terminal"
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

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Example special workspace (scratchpad)
        "$mainMod, S, togglespecialworkspace, magic"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # Enable XF86 (media) keys
        #",XF86AudioMedia, exec, " # Not sure what this one does
        ",XF86AudioPrev, exec, playerctl previous"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioStop, exec, playerctl play-pause"

        # Screenshot
        ", Print, exec, grimblast copysave area --freeze"

        # Reload hyprland
        "CTRL + ALT, delete, exec, hyprctl reload && systemctl restart --user waybar hypridle"
      ];
      # bind[r]e[peat]
      binde = [
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle"
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_SINK@ 5%-"

        ",XF86MonBrightnessUp, exec, brillo -A 5"
        ",XF86MonBrightnessDown, exec, brillo -U 5"
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
          # Make special workspaces (scratchpad) slide in vertically
          "specialWorkspace, 1, 6, default, slidefadevert"
        ];
      };
      decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        rounding = 10;
        # Performance tweaks
        blur = {
          enabled = false;
          size = 2;
          passes = 1;
        };
        drop_shadow = false;
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
