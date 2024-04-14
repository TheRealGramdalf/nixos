{
  config,
  lib,
  pkgs,
  ...
}: {
  systemd.user.services."waybar" = {
    Service = {
      Environment = [
        # Add `hyprctl` to the path so we can dispatch user actions
        "PATH=$PATH:${lib.makeBinPath [pkgs.hyprland]}"
        # Uncomment this to do live debugging & styling
        #"GTK_DEBUG=interactive"
      ];
    };
  };
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      @import "mocha.css";

      * {
        font-family: FantasqueSansMono Nerd Font;
        font-size: 17px;
        min-height: 0;
      }
      /* Set default padding & background */
      #workspaces,
      #custom-music,
      #tray,
      #network,
      #clock,
      #battery,
      #pulseaudio,
      #custom-quit,
      #custom-lock,
      #custom-suspend,
      #custom-reboot,
      #custom-poweroff {
        background-color: @surface0;
        padding: 0.5rem 1rem;
        margin: 5px 0;
      }

      #waybar {
        background: transparent;
        color: @text;
        margin: 5px 5px;
      }

      /* Make tooltips follow catpuccin */
      tooltip {
        background: @base;
        border: 1px solid @pink;
      }
      tooltip label {
        color: @text;
      }


      #workspaces {
        border-radius: 1rem;
        margin-left: 1rem;
        padding: 0;
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

      #tray {
        margin-right: 1rem;
        border-radius: 1rem;
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

      #battery {
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

      /* Powermenu group */
      #custom-quit {
          border-radius: 1rem 0px 0px 1rem;
          color: @lavender;
      }
      #custom-lock {
          border-radius: 0;
          color: @lavender;
      }
      #custom-suspend {
          border-radius: 0;
          color: @lavender;
      }
      #custom-reboot {
          border-radius: 0;
          color: @peach;
      }
      #custom-poweroff {
          margin-right: 1rem;
          border-radius: 1rem;
          color: @red;
      }
    '';
    settings = {
      mainBar = {
        layer = "top";
        modules-left = ["hyprland/workspaces"];
        #modules-center = ["custom/music"];
        modules-right = ["tray" "pulseaudio" "network" "battery" "clock" "group/group-power"];
        position = "top";
        battery = {
          format = "{icon}";
          format-alt = "{icon}";
          format-charging = "󰂄";
          format-icons = ["󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          format-plugged = "";
          states = {
            critical = 15;
            warning = 30;
          };
        };
        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%d/%m/%Y}";
          timezone = "America/Vancouver";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        network = {
          format-wifi = "{icon}";
          format-icons = ["󰤟" "󰤢" "󰤥" "󰤨"];
          format-disconnected = "󰤯";
          format-ethernet = "󰈀";
          tooltip = true;
          tooltip-format-wifi = "<big>{essid}</big>\n<small>󰩟 {ipaddr}/{cidr}</small>\n<small>󱨂 {signalStrength}</small>";
          tooltip-format-ethernet = "<big>{ifname}</big>\n<small>󰩟 {ipaddr}/{cidr}</small>";
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

        "custom/poweroff" = {
          format = "";
          on-click = "hyprctl dispatch exec 'systemctl poweroff'";
          tooltip = false;
        };
        "custom/quit" = {
          format = "󰗼";
          on-click = "hyprctl dispatch exit";
          tooltip = false;
        };
        "custom/reboot" = {
          format = "󰜉";
          on-click = "hyprctl dispatch exec 'systemctl restart'";
          tooltip = false;
        };
        "custom/lock" = {
          format = "";
          on-click = "hyprctl dispatch exec 'hyprlock'";
          tooltip = false;
        };
        "custom/suspend" = {
          format = "󰤄";
          on-click = "hyprctl dispatch exec 'hyprlock & systemctl suspend'";
          tooltip = false;
        };
        "group/group-power" = {
          drawer = {
            children-class = "not-power";
            transition-duration = 500;
            transition-left-to-right = false;
          };
          # The first module in the list is shown as the initial button
          modules = ["custom/poweroff" "custom/quit" "custom/lock" "custom/suspend" "custom/reboot"];
          orientation = "inherit";
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
