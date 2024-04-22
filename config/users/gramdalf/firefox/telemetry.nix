{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.firefox = {
    policies = {
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
    };
  };
}