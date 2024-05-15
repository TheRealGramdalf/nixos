{lib, ...}: {
  services.chrony = lib.mkDefault {
    directory = "/persist/chrony";
    enable = true;
  };
  services.avahi = lib.mkDefault {
    enable = true;
    ipv6 = true;
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = true;
  };
}
