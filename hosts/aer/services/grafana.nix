{
  inputs,
  config,
  lib,
  ...
}: {
  services.grafana = {
    enable = true;
    dataDir = "/persist/services/grafana";
    #configuration = {};
  };

  systemd.services = inputs.tome.mkUnixdService {
    nixosConfig = config;
    inherit lib;
    serviceName = "grafana";
  };
  # Disable the user created by the module
  # The group is still created
  users.users."grafana".enable = false;
}
