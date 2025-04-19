{inputs}: let
  inherit (inputs.nixpkgs) pkgsLib;
in {
  lib = {
    #mkTraefik = servicename: lbserver:
    mkUnixdService = service: user: group: {
      "${service}" = {
        serviceConfig = pkgsLib.mkIf (user || group != null) {
          User = user;
          Group = group;
        };
        after = [
          config.systemd.services."kanidm-unixd".name
        ];
        requires = [
          config.systemd.services."kanidm-unixd".name
        ];
      };
    };
  };
}
