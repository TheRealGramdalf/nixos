lib: {
  #mkTraefik = servicename: lbserver:
  mkUnixdService = {
    nixosConfig,
    serviceName,
    extraServiceConfig ? null,
    ...
  }: {
    "${serviceName}" = {
      serviceConfig = lib.mkIf (extraServiceConfig != null) extraServiceConfig;
      # Using the `.name` attribute will throw an error if `kanidm-unixd` is not defined
      after = [
        nixosConfig.systemd.services."kanidm-unixd".name
      ];
      requires = [
        nixosConfig.systemd.services."kanidm-unixd".name
      ];
    };
  };
}
