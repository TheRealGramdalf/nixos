_: {
  services.cone = {
    enable = true;
    # Traefik's user/group must be local, since it's required for `kanidm-unixd` to function properly
    dataDir = "/persist/services/traefik";
  };
  networking.firewall = {
    allowedUDPPorts = [80 443];
    allowedTCPPorts = [80 443];
  };
}
