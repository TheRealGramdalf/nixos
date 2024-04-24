{
  config,
  lib,
  pkgs,
  ...
}: {
  services.chrony = {
    directory = "/persist/chrony";
    enable = true;
  };
}
