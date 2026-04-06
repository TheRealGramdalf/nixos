{
  config,
  pkgs,
  ...
}: {
  services = {
    thermald.enable = true;
  };
}
