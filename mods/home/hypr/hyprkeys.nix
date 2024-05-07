{ config, lib, pkgs, ... }:
let
  inherit (lib) types;
  inherit (lib) mkEnableOption;
  inherit (lib) mkOption;
  cfg = config.tomeutils.hyprkeys;
in {
  options.tomeutils.hyprkeys = {
    enable = mkEnableOption "Enable selected keybinds" // { default = true; };
    volume = {
      enable = mkEnableOption "Enable volume keybinds (Volume +/-, mute)"; # Enable if `osConfig` pipewire
      backend = mkOption types.oneOf ["wpctl"];
      steps = mkOption types.int {
        default = 5;
        description = "How much to step the volume by on each activation";
      };
    };
    media = {
      enable = mkEnableOption "Enable media keybinds (Play/Pause, seek track)"; # default true
      backend = mkOption types.oneOf ["playerctl"];
    };
    brightness = {
      enable = mkEnableOption "Enable brightness keybinds"; # Enable if `osConfig` brillo?
      backend = mkOption types.oneOf ["brillo"]; #"brightnessctl"
    };
    screenshot = {
      enable = mkEnableOption "Enable screenshot (printscreen) keybinds, powered by `grimblast`"; # default true
      backend = types.oneOf ["grimblast"];
      args = mkOption types.str {
        default = "copysave area --freeze";
        description = "Verbatim args passed to `grimblast`";
      };
    };
  };

  # Implementation
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.enable -> !config.programs.hyprland.enable;
        message = "Hyprland must be enabled for `hyprkeys` to work";
      }
    ];
    wayland.windowManager.hyprland.settings = {
      binde = [
        (lib.lists.optionals cfg.volume.enable ",XF86AudioMute, exec, ${cfg.volume.backend} set-mute @DEFAULT_SINK@ toggle")
        (lib.lists.optionals cfg.volume.enable ",XF86AudioRaiseVolume, exec, ${cfg.volume.backend} set-volume -l 1.0 @DEFAULT_SINK@ ${cfg.volume.steps}%+")
        (lib.lists.optionals cfg.volume.enable ",XF86AudioLowerVolume, exec, ${cfg.volume.backend} -l 1.0 @DEFAULT_SINK@ ${cfg.volume.steps}%-")

        (lib.lists.optionals cfg.brightness.enable",XF86MonBrightnessUp, exec, ${cfg.brightness.backend} -A ${cfg.brightness.steps}")
        (lib.lists.optionals cfg.brightness.enable",XF86MonBrightnessDown, exec, ${cfg.brightness.backend} -U ${cfg.brightness.steps}")
      ];
    };
    home.packages = [
      (lib.lists.optionals cfg.screenshot.enable pkgs.grimblast)
    ];
  };
}