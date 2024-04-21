{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  services = {
    fprintd.enable = true;
  };
}
