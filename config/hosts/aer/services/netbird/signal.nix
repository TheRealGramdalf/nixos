{config, ...}: let
  cfg = config.services.netbird.server;
  sigPort = "${toString cfg.signal.port}";
in {
  services.netbird.server = {
    signal = {
      port = 6968;
      logLevel = "DEBUG";
    };
  };

  services.cone.extraFiles = {
    "netbird-signal".settings = {
      http.routers."netbird-signal" = {
        rule = "Host(`${cfg.domain}`) && PathPrefix(`/signalexchange.SignalExchange/`)";
        service = "netbird-signal";
      };
      http.services."netbird-signal".loadbalancer.servers = [{url = "h2c://127.0.0.1:${sigPort}";}];
    };
  };
}
