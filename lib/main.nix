lib: let
  inherit (lib) mkIf mkForce;
in {
  #mkTraefik = servicename: lbserver:
  mkUnixdService = {
    nixosConfig,
    serviceName,
    serviceUser ? null,
    serviceGroup ? null,
    extraServiceConfig ? null,
    ...
  }: {
    "${serviceName}" = {
      serviceConfig =
        mkIf (serviceUser != null || serviceGroup != null) {
          User = mkIf (serviceUser != null) (mkForce serviceUser);
          Group = mkIf (serviceGroup != null) (mkForce serviceGroup);
        }
        // mkIf (extraServiceConfig != null) extraServiceConfig;
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
