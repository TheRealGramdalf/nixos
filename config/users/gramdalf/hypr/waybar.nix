{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    #style = ''
    #  @import "mocha.css";
    #
    #  * {
    #    font-family: FantasqueSansMono Nerd Font;
    #    font-size: 19px;
    #    min-height: 0;
    #  }
    #
    #  window#waybar {
    #    background: transparent;
    #  }
    #
    #  #workspaces {
    #    border-radius: 1rem;
    #    background-color: @surface0;
    #    margin-top: 1rem;
    #    margin: 7px 3px 0px 7px;
    #  }
    #
    #  #workspaces button {
    #    color: @pink;
    #    border-radius: 1rem;
    #    padding-left: 6px;
    #    margin: 5px 0;
    #    box-shadow: inset 0 -3px transparent;
    #    transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.68);
    #    background-color: transparent;
    #  }
    #
    #  #workspaces button.active {
    #    color: @flamingo;
    #    border-radius: 1rem;
    #  }
    #
    #  #workspaces button:hover {
    #    color: @rosewater;
    #    border-radius: 1rem;
    #  }
    #
    #  #tray,
    #  #network,
    #  #backlight,
    #  #clock,
    #  #battery,
    #  #pulseaudio,
    #  #custom-lock,
    #  #custom-power {
    #    background-color: @surface0;
    #    margin: 7px 3px 0px 7px;
    #    padding: 10px 5px 10px 5px;
    #    border-radius: 1rem;
    #  }
    #
    #  #clock {
    #    color: @lavender;
    #  }
    #
    #  #battery {
    #    color: @green;
    #  }
    #
    #  #battery.charging {
    #    color: @green;
    #  }
    #
    #  #battery.warning:not(.charging) {
    #    color: @red;
    #  }
    #
    #  #network {
    #      color: @flamingo;
    #  }
    #
    #  #backlight {
    #    color: @yellow;
    #  }
    #
    #  #pulseaudio {
    #    color: @pink;
    #  }
    #
    #  #pulseaudio.muted {
    #      color: @red;
    #  }
    #
    #  #custom-power {
    #      border-radius: 1rem;
    #      color: @red;
    #      margin-bottom: 1rem;
    #  }
    #
    #  #tray {
    #    border-radius: 1rem;
    #  }
    #
    #  tooltip {
    #      background: @base;
    #      border: 1px solid @pink;
    #  }
    #
    #  tooltip label {
    #      color: @text;
    #  }
    #'';
    style = ''
      @import "mocha.css";

      * {
        font-family: FantasqueSansMono Nerd Font;
        font-size: 17px;
        min-height: 0;
      }

      #waybar {
        background: transparent;
        color: @text;
        margin: 5px 5px;
      }

      #workspaces {
        border-radius: 1rem;
        margin: 5px;
        background-color: @surface0;
        margin-left: 1rem;
      }

      #workspaces button {
        color: @lavender;
        border-radius: 1rem;
        padding: 0.4rem;
      }

      #workspaces button.active {
        color: @sky;
        border-radius: 1rem;
      }

      #workspaces button:hover {
        color: @sapphire;
        border-radius: 1rem;
      }

      #custom-music,
      #tray,
      #backlight,
      #clock,
      #battery,
      #pulseaudio,
      #custom-lock,
      #custom-power {
        background-color: @surface0;
        padding: 0.5rem 1rem;
        margin: 5px 0;
      }

      #clock {
        color: @blue;
        border-radius: 0px 1rem 1rem 0px;
        margin-right: 1rem;
      }

      #battery {
        color: @green;
      }

      #battery.charging {
        color: @green;
      }

      #battery.warning:not(.charging) {
        color: @red;
      }

      #backlight {
        color: @yellow;
      }

      #backlight, #battery {
          border-radius: 0;
      }

      #pulseaudio {
        color: @maroon;
        border-radius: 1rem 0px 0px 1rem;
        margin-left: 1rem;
      }

      #custom-music {
        color: @mauve;
        border-radius: 1rem;
      }

      #custom-lock {
          border-radius: 1rem 0px 0px 1rem;
          color: @lavender;
      }

      #custom-power {
          margin-right: 1rem;
          border-radius: 0px 1rem 1rem 0px;
          color: @red;
      }

      #tray {
        margin-right: 1rem;
        border-radius: 1rem;
      }
    '';
    #settings = {
    #  mainBar = {
    #    layer = "top";
    #    "hyprland/workspaces" = {disable-scroll = false;};
    #    modules-left = ["hyprland/workspaces"];
    #    modules-center = ["clock"];
    #    modules-right = [ "tray" "cpu" "backlight" "battery"];
    #  };
    #};
    #settings = {
    #mainBar = {
    #  layer = "top";
    #  position = "top";
    #  modules-left = ["hyprland/workspaces"];
    #  modules-center = [];
    #  modules-right = ["pulseaudio" "network" "backlight" "battery" "clock" "tray" "custom/power"];
    #
    #  "hyprland/workspaces" = {
    #    disable-scroll = true;
    #    sort-by-name = true;
    #    format = "{icon}";
    #    format-icons = {default = "";};
    #  };
    #
    #  pulseaudio = {
    #    format = " {icon} ";
    #    format-muted = "ﱝ";
    #    format-icons = ["奄" "奔" "墳"];
    #    tooltip = true;
    #    tooltip-format = "{volume}%";
    #  };
    #
    #  network = {
    #    format-wifi = " ";
    #    format-disconnected = "睊";
    #    format-ethernet = " ";
    #    tooltip = true;
    #    tooltip-format = "{signalStrength}%";
    #  };
    #
    #  backlight = {
    #    device = "intel_backlight";
    #    format = "{icon}";
    #    format-icons = ["" "" "" "" "" "" "" "" ""];
    #    tooltip = true;
    #    tooltip-format = "{percent}%";
    #  };
    #
    #  battery = {
    #    states = {
    #      warning = 30;
    #      critical = 15;
    #    };
    #    format = "{icon}";
    #    format-charging = "";
    #    format-plugged = "";
    #    format-icons = ["" "" "" "" "" "" "" "" "" "" "" ""];
    #    tooltip = true;
    #    tooltip-format = "{capacity}%";
    #  };
    #
    #  "custom/power" = {
    #    tooltip = false;
    #    on-click = "powermenu";
    #    format = "襤";
    #  };
    #
    #  clock = {
    #    tooltip-format = ''
    #      <big>{:%Y %B}</big>
    #      <tt><small>{calendar}</small></tt>'';
    #    format-alt = ''
    #       {:%d
    #       %m
    #      %Y}'';
    #    format = ''
    #      {:%H
    #      %M}'';
    #  };
    #
    #  tray = {
    #    icon-size = 21;
    #    spacing = 10;
    #  };
    #};
    #};
    settings = {
      mainBar = {
        layer = "top";
        modules-left = ["hyprland/workspaces"];
        modules-center = ["custom/music"];
        modules-right = ["tray" "pulseaudio" "backlight" "battery" "clock" "custom/lock" "custom/power"];
        position = "top";
        backlight = {
          device = "intel_backlight";
          format = "{icon}";
          format-icons = ["" "" "" "" "" "" "" "" ""];
        };
        battery = {
          format = "{icon}";
          format-alt = "{icon}";
          format-charging = "";
          format-icons = ["" "" "" "" "" "" "" "" "" "" "" ""];
          format-plugged = "";
          states = {
            critical = 15;
            warning = 30;
          };
        };
        clock = {
          format = " {:%H:%M}";
          format-alt = " {:%d/%m/%Y}";
          timezone = "Asia/Dubai";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        "custom/lock" = {
          format = "";
          on-click = "sh -c '(sleep 0.5s; swaylock --grace 0)' & disown";
          tooltip = false;
        };
        "custom/music" = {
          escape = true;
          exec = "playerctl metadata --format='{{ title }}'";
          format = "  {}";
          interval = 5;
          max-length = 50;
          on-click = "playerctl play-pause";
          tooltip = false;
        };
        "custom/power" = {
          format = "襤";
          on-click = "wlogout &";
          tooltip = false;
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-icons = {default = ["" "" " "];};
          format-muted = "";
          on-click = "pavucontrol";
        };
        tray = {
          icon-size = 21;
          spacing = 10;
        };
        "hyprland/workspaces" = {
          disable-scroll = true;
          format = " {icon} ";
          format-icons = {default = "";};
          sort-by-name = true;
        };
      };
    };
  };
  home.file.".config/waybar/mocha.css".source =
    pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "waybar";
      rev = "v1.1";
      hash = "sha256-9lY+v1CTbpw2lREG/h65mLLw5KuT8OJdEPOb+NNC6Fo=";
    }
    + "/themes/mocha.css";
}
