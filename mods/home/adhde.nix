{
  config,
  osConfig,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkMerge mkIf;
  cfg = config.tomeutils.adhde;
in {
  imports = [
    inputs.anyrun.homeManagerModules.default
  ];
  options.tomeutils.adhde = {
    enable = mkEnableOption "ADHDE, a set of usable Hyprland defaults for the scatterbrained" // {default = false;};

    anyrun = {
      enable = mkEnableOption "Anyrun, a powerful launcher written in rust" // {default = true;};
      bind = mkEnableOption "a keybind for launching Anyrun with `\${mainMod} + [SPACE]`" // {default = true;};
    };

    gtk.enable = mkEnableOption "a GTK theme/icon theme to make things look nice" // {default = true;};
    cursor.enable = mkEnableOption "a cursor theme to make things look nice" // {default = true;};

    idle = {
      enable = mkEnableOption "Hypridle, an idle management daemon for session locking/power saving" // {default = true;};
      sleep = mkEnableOption "the sleep timer. Note that Hypridle will always start `hyprlock` before sleep." // {default = false;};
    };

    hyprlock.enable = mkEnableOption "Hyprlock, the GPU accelerated lock screen for Hyprland" // {default = true;};
  };

  ##### Implementation
  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.gtk.enable {
      home.packages = [pkgs.glib]; # gsettings
      # Use `nwg-look` to test out themes
      gtk = {
        enable = true;
        theme = {
          name = "catppuccin-mocha-mauve-standard";
          package = pkgs.catppuccin-gtk.override {
            accents = ["mauve"];
            #tweaks = [ "rimless" "black" ];
            variant = "mocha";
          };
        };
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.catppuccin-papirus-folders.override {
            flavor = "mocha";
            accent = "mauve";
          };
        };
      };
      # Symlinking the `~/.config/gtk-4.0/` folder is done by home-manager automatically
      # Enable dark mode for certain apps
      dconf.settings."org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    })

    (mkIf cfg.cursor.enable {
      home.pointerCursor = {
        size = 24;
        gtk.enable = true;
        x11.enable = true;
        package = pkgs.catppuccin-cursors.mochaLavender;
        name = "catppuccin-mocha-lavender-cursors";
      };
    })

    (mkIf cfg.anyrun.enable {
      programs.anyrun = {
        enable = true;
        config = {
          plugins = with inputs.anyrun.packages.${pkgs.system}; [
            applications
            rink
            symbols
            randr
          ];
          closeOnClick = false;
          showResultsImmediately = false;
          maxEntries = 20;
          width.fraction = 0.3;
          x.fraction = 0.5;
          y.fraction = 0.1;
        };
        extraCss = ''
          label#match-desc {
            font-size: 10px;
          }

          label#plugin {
            font-size: 14px;
          }
          #window {
            background-color = transparent;
          }
        '';
      };
    })

    (mkIf cfg.anyrun.bind {
      wayland.windowManager.hyprland.settings.bind = [
        "$mainMod, SPACE, exec, anyrun"
      ];
    })

    (mkIf cfg.idle.enable {
      assertions = [
        {
          assertion = cfg.hyprlock.enable;
          message = "`hypridle` will leave your system unlocked if `hyprlock` is not enabled";
        }
      ];
      services.hypridle = {
        enable = true;
        settings = {
          general = {
            # Avoid running hyprlock twice
            lock_cmd = "hyprctl dispatch exec 'pidof hyprlock || hyprlock'"; # Commands to run when `loginctl lock-session` is called
            #unlock_cmd = notify-send "unlock!"      # same as above, but unlock
            # Use this to debug sleep
            before_sleep_cmd = "hyprctl dispatch exec 'loginctl lock-session'"; # run the `lock_cmd` via `loginctl` before sleep
            #after_sleep_cmd = "";  # command ran after sleep
            ignore_dbus_inhibit = false; # whether to ignore dbus-sent idle-inhibit requests (used by e.g. firefox or steam)
          };

          listener = [
            {
              timeout = 300; # 5m
              on-timeout = "hyprctl dispatch exec 'loginctl lock-session'"; # command to run when timeout has passed
            }

            (mkIf cfg.idle.sleep {
              timeout = 600; # 10m
              on-timeout = "hyprctl dispatch exec 'systemctl suspend'";
            })
          ];
        };
      };
    })

    (mkIf cfg.hyprlock.enable {
      assertions = [
        {
          assertion = osConfig.tomeutils.adhde.enable;
          message = "`hyprlock` requires OS level PAM configuration to work properly. Enable the NixOS Module to set it up.";
        }
      ];
      programs.hyprlock = {
        enable = true;
        settings = {
          source = "~/.config/hypr/mocha.conf";
          general = {
            disable_loading_bar = true;
            hide_cursor = true;
          };
          # BACKGROUND
          background = {
            monitor = "";
            #path = "~/.config/background";
            blur_passes = 0;
            # Used as the fallback if `path` doesn't exist
            color = "$base";
          };
          label = [
            {
              # TIME
              monitor = "";
              text = ''cmd[update:30000] echo "$(date +"%R")"'';
              color = "$text";
              font_size = 90;
              font_family = "JetBrainsMono Nerd Font";
              position = "-30, 0";
              halign = "right";
              valign = "top";
            }
            {
              # DATE
              monitor = "";
              text = ''cmd[update:43200000] echo "$(date +"%A, %d %B %Y")"'';
              color = "$text";
              font_size = 25;
              font_family = "JetBrainsMono Nerd Font";
              position = "-30, -150";
              halign = "right";
              valign = "top";
            }
          ];
          # USER AVATAR
          #image {
          #    path = ~/.face
          #    size = 100
          #    border_color = $mauve
          #
          #    position = 0, 75
          #    halign = center
          #    valign = center
          #}
          input-field = {
            monitor = "";
            size = "300, 60";
            outline_thickness = 4;
            dots_size = 0.2;
            dots_spacing = 0.2;
            dots_center = true;
            outer_color = "$mauve";
            inner_color = "$surface0";
            font_color = "$text";
            fade_on_empty = false;
            placeholder_text = ''
              <span foreground="##$textAlpha"><i>󰌾 Logged in as </i><span foreground="##$mauveAlpha">$USER</span></span>
            '';
            hide_input = false;
            check_color = "$mauve";
            fail_color = "$red";
            fail_text = ''
              <i>$FAIL <b>($ATTEMPTS)</b></i>
            '';
            capslock_color = "$yellow";
            position = "0, -35";
            halign = "center";
            valign = "center";
          };
        };
      };
    })
  ]);
}
