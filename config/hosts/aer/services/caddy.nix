{...}: {
  services.caddy = {
    enable = true;
    user = "";
    group = "";
    dataDir = "/persist/services/caddy";
    globalConfig = ''
      #debug
      grace_period 10s
    ''
  };
}
