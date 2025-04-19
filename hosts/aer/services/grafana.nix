{pkgs, ... }: {
  services.grafana = {
    enable = true;
    dataDir = "/persist/services/grafana";
    configuration = {};
  };


  systemd.services."grafana" = {
    after = [
      config.systemd.services."kanidm-unixd".name
    ];
    requires = [
      config.systemd.services."kanidm-unixd".name
    ];
    serviceConfig = {
      User = "";
      Group = "";
    };
  };
  # Disable the user created by the module
  # The group is still created
  users.users."grafana".enable = false;
}