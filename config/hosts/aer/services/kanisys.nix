{lib, ...}: let
  inherit (lib) mapAttrs filterAttrs;
in {
systemd = mapAttrs (
    n: v: {
      services.n = {
        after = ["kanidm-unixd.service"];
        requires = ["kanidm-unixd.service"];
      };
    }
  ) (filterAttrs (
      n: v:
        !isNull (builtins.match "([[:xdigit:]]{8}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{12})" v.serviceConfig.Group)
        && !isNull (builtins.match "([[:xdigit:]]{8}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{12})" v.serviceConfig.User)
        && config.users.users.${v.serviceConfig.User} != {}
        && config.users.groups.${v.serviceConfig.Group} != {}
    )
    config.systemd.services)
}