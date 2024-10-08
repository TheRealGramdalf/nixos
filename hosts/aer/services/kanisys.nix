{lib, config, ...}: let
  inherit (lib) mapAttrs filterAttrs;
  #sysFiltered = filterAttrs (
  #    n: v:
  #      !isNull (builtins.match "([[:xdigit:]]{8}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{12})" v.serviceConfig.Group)
  #      #&& !isNull (builtins.match "([[:xdigit:]]{8}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{12})" v.serviceConfig.User)
  #      #&& config.users.users.${v.serviceConfig.User} != {}
  #      #&& config.users.groups.${v.serviceConfig.Group} != {}
  #  )
  #  config.systemd.services;
  sysMapped = mapAttrs (
    n: v: {
      services.n = {
        after = ["kanidm-unixd.service"];
        requires = ["kanidm-unixd.service"];
      };
    }
  ) config.systemd.services;
in {
  systemd.services = sysMapped;
}
