{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.tomeutils.adhde;
in {
  options.tomeutils.adhde = {
    enable = mkEnableOption "ADHDE, a set of usable Hyprland defaults for the scatterbrained";
  };

  config = mkIf cfg.enable {
}
