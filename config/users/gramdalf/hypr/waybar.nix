{ config, lib, pkgs, ... }: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      @import "mocha.css";

      * {
        font-family: FantasqueSansMono Nerd Font;
        font-size: 19px;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
      }

      #workspaces {
        border-radius: 1rem;
        background-color: @surface0;
        margin-top: 1rem;
        margin: 7px 3px 0px 7px;
      }

      #workspaces button {
        color: @pink;
        border-radius: 1rem;
        padding-left: 6px;
        margin: 5px 0;
        box-shadow: inset 0 -3px transparent;
        transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.68);
        background-color: transparent;
      }

      #workspaces button.active {
        color: @flamingo;
        border-radius: 1rem;
      }

      #workspaces button:hover {
        color: @rosewater;
        border-radius: 1rem;
      }

      #tray,
      #network,
      #backlight,
      #clock,
      #battery,
      #pulseaudio,
      #custom-lock,
      #custom-power {
        background-color: @surface0;
        margin: 7px 3px 0px 7px;
        padding: 10px 5px 10px 5px;
        border-radius: 1rem;
      }

      #clock {
        color: @lavender;
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

      #network {
          color: @flamingo;
      }

      #backlight {
        color: @yellow;
      }

      #pulseaudio {
        color: @pink;
      }

      #pulseaudio.muted {
          color: @red;
      }

      #custom-power {
          border-radius: 1rem;
          color: @red;
          margin-bottom: 1rem;
      }

      #tray {
        border-radius: 1rem;
      }

      tooltip {
          background: @base;
          border: 1px solid @pink;
      }

      tooltip label {
          color: @text;
      }
    '';
    settings = {
      mainBar = {
        layer = "top";
        "hyprland/workspaces" = {disable-scroll = false;};
        modules-left = ["hyprland/workspaces"];
        modules-center = ["clock"];
        modules-right = [ "tray" "cpu" "backlight" "battery"];
      };
    };
  };
  home.file.".config/waybar/mocha.css".source = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "waybar";
    rev = "v1.1";
    hash = "sha256-9lY+v1CTbpw2lREG/h65mLLw5KuT8OJdEPOb+NNC6Fo=";
  } + "/themes/mocha.css"; 
}