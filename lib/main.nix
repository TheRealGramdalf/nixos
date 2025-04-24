lib: {
  #mkTraefik = servicename: lbserver:
  mkUnixdService = {
    nixosConfig,
    serviceName,
    serviceUser ? null,
    serviceGroup ? null,
    lib,
  }: {
    "${serviceName}" = {
      serviceConfig = lib.mkIf (serviceUser != null || serviceGroup != null) {
        User = lib.mkIf (serviceUser != null) (lib.mkForce serviceUser);
        Group = lib.mkIf (serviceGroup != null) (lib.mkForce serviceGroup);
      };
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
