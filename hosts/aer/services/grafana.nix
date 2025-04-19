{pkgs, inputs, ... }: {
  services.grafana = {
    enable = true;
    dataDir = "/persist/services/grafana";
    configuration = {};
  };


  systemd.services = imputs.tome.lib.mkUnixdSarvice (x: "grafana");
  # Disable the user created by the module
  # The group is still created
  users.users."grafana".enable = false;
}