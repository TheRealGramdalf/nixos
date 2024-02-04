{ inputs, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  config = {
    services = {
      # Consume POSIX accounts from Kanidm
      kanidm = {
        enablePam = true;
        clientSettings.uri = "https://auth.aer.dedyn.io";
        unixSettings = {
          default_shell = "/bin/bash";
          home_prefix = "/home/";
          home_attr = "uuid";
          home_alias = "spn";
          use_etc_skel = false;
          uid_attr_map = "spn";
          gid_attr_map = "spn";
          selinux = true;
      };};
    };
  };
}
