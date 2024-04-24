{
  config,
  lib,
  ...
}: {
  services.chrony = lib.mkDefault {
    directory = "/persist/chrony";
    enable = true;
  };
  services.avahi = lib.mkDefault {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
