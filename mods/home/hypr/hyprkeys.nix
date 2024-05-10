{ config, lib, pkgs, osConfig, ... }:
let
  inherit (lib) types;
  inherit (lib) mkEnableOption mkMerge mkOption optionals;
  cfg = config.tomeutils.hyprkeys;
in {
  ###### Definition
  options.tomeutils.hyprkeys = {
    enable = mkEnableOption "selected keybinds"
    // { default = (config.wayland.windowManager.hyprland.enable); };

    volume = {
      enable = mkEnableOption "volume keybinds (Volume +/-, mute)"
      // { default = (osConfig.services.pipewire.enable); };
      steps = mkOption {
        type = types.int;
        default = 5;
        description = "How much to step the volume by on each activation";
      };
    };

    media.enable = mkEnableOption "media keybinds (Play/Pause, seek track), powered by `playerctl`"
    // { default = (osConfig.services.pipewire.enable); };

    reload.enable = mkEnableOption "hyprland/waybar reload keybind (ctrl + alt + delete)"
    // { default = true; };

    workspaces = {
      enable = mkEnableOption "basic workspace keybinds, based on the hyprland starter config"
      // { default = true; };
      scratchpad.enable = mkEnableOption "a drop-down style special workspace"
      // { default = false; };
    };

    brightness = {
      enable = mkEnableOption "brightness keybinds"
      // { default = (osConfig.hardware.brillo.enable); };
      steps = mkOption {
        type = types.int;
        default = 5;
        description = "How much to step the volume by on each activation";
      };
    };
    screenshot = {
      enable = mkEnableOption "screenshot (printscreen) keybinds, powered by `grimblast`"
      // { default = true; };
      args = mkOption {
        type = types.str;
        default = "copysave area --freeze";
        description = "Verbatim args passed to `grimblast`";
      };
    };
  };

  # Implementation
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      # Set the mainmod in case it isn't elsewhere
      "$mainMod" = lib.mkDefault "SUPER";
      # bind[r]e[peat]
      binde = mkMerge [
        (optionals cfg.volume.enable [
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle"
          ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_SINK@ ${builtins.toString cfg.volume.steps}%+"
          ",XF86AudioLowerVolume, exec, wpctl -l 1.0 @DEFAULT_SINK@ ${builtins.toString cfg.volume.steps}%-"
        ])

        (optionals cfg.brightness.enable [
          ",XF86MonBrightnessUp, exec, brillo -A ${builtins.toString cfg.brightness.steps}"
          ",XF86MonBrightnessDown, exec, brillo -U ${builtins.toString cfg.brightness.steps}"
        ])
      ];
      bind = mkMerge [
        (optionals cfg.screenshot.enable ["grimblast ${cfg.screenshot.args}"])
        (optionals cfg.media.enable [
          ",XF86AudioPrev, exec, playerctl previous"
          ",XF86AudioNext, exec, playerctl next"
          ",XF86AudioPlay, exec, playerctl play-pause"
          ",XF86AudioStop, exec, playerctl play-pause"
        ])
        (optionals cfg.reload.enable [
          # Reload hyprland
          "CTRL + ALT, delete, exec, hyprctl reload && systemctl restart --user waybar hypridle"
        ])
        (optionals cfg.workspaces.enable [
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
        ])
        (optionals cfg.workspaces.scratchpad.enable [
          # Special workspace (scratchpad)
          "$mainMod, S, togglespecialworkspace, magic"
        ])
      ];
      bindm = mkMerge [
        (optionals cfg.workspaces.enable [
          # Scroll through existing workspaces with mainMod + scroll
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
        ])
      ];
      animations.animation = mkMerge [
        (optionals cfg.workspaces.scratchpad.enable [
        # Make special workspaces (scratchpad) slide in vertically
        "specialWorkspace, 1, 6, default, slidefadevert"
        ])
      ];
    };
    home.packages = mkMerge [
      (optionals cfg.screenshot.enable [pkgs.grimblast])
      (optionals cfg.media.enable [pkgs.playerctl])
    ];
  };
}