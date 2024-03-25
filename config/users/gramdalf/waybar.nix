{ config, lib, pkgs, ... }: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      backlight = {
        device = "intel_backlight";
        format = "{percent}% {icon}";
        format-icons = [""];
        min-length = 7;
      };
      battery = {
        format = "{capacity}% {icon}";
        format-alt = "{time} {icon}";
        format-charging = "{capacity}% ";
        format-icons = ["" "" "" "" "" "" "" "" "" ""];
        format-plugged = "{capacity}% ";
        on-update = "$HOME/.config/waybar/scripts/check_battery.sh";
        states = {
          critical = 15;
          warning = 30;
        };
      };
      clock = {
        format = "{:%a, %d %b, %I:%M %p}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };
      cpu = {
        format = "{usage}% ";
        interval = 2;
        min-length = 6;
      };
      "custom/mail" = {
        exec = "$HOME/.config/waybar/scripts/checkgmail.py";
        format = "{} ";
        interval = 120;
        on-click = "google-chrome-stable https://mail.google.com/mail/u/0/#inbox ; pkill -SIGRTMIN+9 waybar";
        signal = 9;
        tooltip = false;
      };
      "custom/mem" = {
        exec = "free -h | awk '/Mem:/{printf $3}'";
        format = "{} ";
        interval = 3;
        tooltip = false;
      };
      "custom/pacman" = {
        exec = "(checkupdates;pacman -Qm | aur vercmp) | wc -l";
        exec-if = "exit 0";
        format = "{} ";
        interval = 3600;
        on-click = "foot sh -c 'yay; echo Done - Press enter to exit; read'; pkill -SIGRTMIN+8 waybar";
        signal = 8;
        tooltip = false;
      };
      "custom/weather" = {
        exec = "$HOME/.config/waybar/scripts/wttr.py";
        format = "{}";
        interval = 1800;
        return-type = "json";
        tooltip = true;
      };
      "hyprland/language" = {
        format-en = "US";
        format-ru = "RU";
        min-length = 5;
        tooltip = false;
      };
      "hyprland/submap" = {format = "pon {}";};
      "hyprland/workspaces" = {disable-scroll = true;};
      keyboard-state = {
        capslock = true;
        format = "{icon} ";
        format-icons = {
          locked = " ";
          unlocked = "";
        };
      };
      layer = "top";
      margin = "9 13 -10 18";
      modules-center = ["clock" "custom/weather"];
      modules-left = ["hyprland/workspaces" "hyprland/language" "keyboard-state" "hyprland/submap"];
      modules-right = ["pulseaudio" "custom/mem" "cpu" "backlight" "battery" "tray"];
      position = "top";
      pulseaudio = {
        format = "{volume}% {icon} {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-icons = {
          car = "";
          default = ["" "" ""];
          hands-free = "";
          headphone = "";
          headset = "";
          phone = "";
          portable = "";
        };
        format-muted = " {format_source}";
        format-source = "{volume}% ";
        format-source-muted = "";
        min-length = 13;
        on-click = "pavucontrol";
        reverse-scrolling = 1;
      };
      temperature = {
        critical-threshold = 80;
        format = "{temperatureC}°C {icon}";
        format-icons = ["" "" "" "" ""];
        tooltip = false;
      };
      tray = {
        icon-size = 16;
        spacing = 0;
      };
    };
    style = ''
    * {
        border: none;
        border-radius: 0;
        /* `otf-font-awesome` is required to be installed for icons */
        font-family: FontAwesome, JetBrains Mono Bold, sans-serif;
        min-height: 20px;
    }

    window#waybar {
        background: transparent;
    }

    window#waybar.hidden {
        opacity: 0.2;
    }

    #workspaces {
        margin-right: 8px;
        border-radius: 10px;
        transition: none;
        background: #383c4a;
    }

    #workspaces button {
        transition: none;
        color: #7c818c;
        background: transparent;
        padding: 5px;
        font-size: 18px;
    }

    #workspaces button.persistent {
        color: #7c818c;
        font-size: 12px;
    }

    /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
    #workspaces button:hover {
        transition: none;
        box-shadow: inherit;
        text-shadow: inherit;
        border-radius: inherit;
        color: #383c4a;
        background: #7c818c;
    }

    #workspaces button.active {
        background: #4e5263;
        color: white;
        border-radius: inherit;
    }

    #language {
        padding-left: 16px;
        padding-right: 8px;
        border-radius: 10px 0px 0px 10px;
        transition: none;
        color: #ffffff;
        background: #383c4a;
    }

    #keyboard-state {
        margin-right: 8px;
        padding-right: 16px;
        border-radius: 0px 10px 10px 0px;
        transition: none;
        color: #ffffff;
        background: #383c4a;
    }

    #custom-pacman {
        padding-left: 16px;
        padding-right: 8px;
        border-radius: 10px 0px 0px 10px;
        transition: none;
        color: #ffffff;
        background: #383c4a;
    }

    #custom-mail {
        margin-right: 8px;
        padding-right: 16px;
        border-radius: 0px 10px 10px 0px;
        transition: none;
        color: #ffffff;
        background: #383c4a;
    }

    #submap {
        padding-left: 16px;
        padding-right: 16px;
        border-radius: 10px;
        transition: none;
        color: #ffffff;
        background: #383c4a;
    }

    #clock {
        padding-left: 16px;
        padding-right: 16px;
        border-radius: 10px 0px 0px 10px;
        transition: none;
        color: #ffffff;
        background: #383c4a;
    }

    #custom-weather {
        padding-right: 16px;
        border-radius: 0px 10px 10px 0px;
        transition: none;
        color: #ffffff;
        background: #383c4a;
    }

    #pulseaudio {
        margin-right: 8px;
        padding-left: 16px;
        padding-right: 16px;
        border-radius: 10px;
        transition: none;
        color: #ffffff;
        background: #383c4a;
    }

    #pulseaudio.muted {
        background-color: #90b1b1;
        color: #2a5c45;
    }

    #custom-mem {
        margin-right: 8px;
        padding-left: 16px;
        padding-right: 16px;
        border-radius: 10px;
        transition: none;
        color: #ffffff;
        background: #383c4a;
    }

    #cpu {
        margin-right: 8px;
        padding-left: 16px;
        padding-right: 16px;
        border-radius: 10px;
        transition: none;
        color: #ffffff;
        background: #383c4a;
    }

    #temperature {
        margin-right: 8px;
        padding-left: 16px;
        padding-right: 16px;
        border-radius: 10px;
        transition: none;
        color: #ffffff;
        background: #383c4a;
    }

    #temperature.critical {
        background-color: #eb4d4b;
    }

    #backlight {
        margin-right: 8px;
        padding-left: 16px;
        padding-right: 16px;
        border-radius: 10px;
        transition: none;
        color: #ffffff;
        background: #383c4a;
    }

    #battery {
        margin-right: 8px;
        padding-left: 16px;
        padding-right: 16px;
        border-radius: 10px;
        transition: none;
        color: #ffffff;
        background: #383c4a;
    }

    #battery.charging {
        color: #ffffff;
        background-color: #26A65B;
    }

    #battery.warning:not(.charging) {
        background-color: #ffbe61;
        color: black;
    }

    #battery.critical:not(.charging) {
        background-color: #f53c3c;
        color: #ffffff;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
    }

    #tray {
        padding-left: 16px;
        padding-right: 16px;
        border-radius: 10px;
        transition: none;
        color: #ffffff;
        background: #383c4a;
    }

    @keyframes blink {
        to {
            background-color: #ffffff;
            color: #000000;
        }
    }
    ''    
  };
}