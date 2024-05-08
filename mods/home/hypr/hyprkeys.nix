{ config, lib, pkgs, osConfig, ... }:
let
  inherit (lib) types;
  inherit (lib) mkEnableOption mkMerge mkOption optionals;
  cfg = config.tomeutils.hyprkeys;
in {
  ###### Definition
  options.tomeutils.hyprkeys = {
    enable = mkEnableOption "selected keybinds"
    // { default = (wayland.windowManager.hyprland); };

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

    brightness = {
      enable = mkEnableOption "brightness keybinds"
      // { (osConfig.hardware.brillo.enable) };
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
      ];
    };
    home.packages = mkMerge [
      (optionals cfg.screenshot.enable [pkgs.grimblast])
      (optionals cfg.media.enable [pkgs.playerctl])
    ];
  };
}