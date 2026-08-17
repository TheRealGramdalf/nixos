{pkgs, ...}: {
  services.kanidm = {
    package = pkgs.kanidm_1_11;
    client.settings.uri = "https://auth.aer.dedyn.io";
    # Unix and client is only configured here, not enabled
    unix.settings = {
      version = "2";
      home_prefix = "/home/";
      home_attr = "uuid";
      home_alias = "spn";
      use_etc_skel = false;
      uid_attr_map = "spn";
      gid_attr_map = "spn";
      selinux = true;
    };
  };
}
