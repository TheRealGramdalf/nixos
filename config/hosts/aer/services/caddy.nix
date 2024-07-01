_: {
  services.caddy = {
    enable = true;
    # Caddy's user/group must be local, since it's required for `kanidm-unixd` to function properly
    dataDir = "/persist/services/caddy";
    globalConfig = ''
      debug
      grace_period 10s
    '';
  };
  networking.firewall = {
    allowedUDPPorts = [80 443];
    allowedTCPPorts = [80 443];
  }
}
