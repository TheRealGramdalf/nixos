{ config, lib, pkgs, ... }: {
  wayland.windowManager.hyprland = {
    settings = {
      input = {
        accel_profile = "flat";
        natural_scroll = true;
        touchpad = {
          accel_profile = "flat";
          natural_scroll = true;
        }
      }
    };
  };
}