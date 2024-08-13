{
  services.kanidm = {
    enablePam = true;
    clientSettings.uri = "https://auth.aer.dedyn.io";
    unixSettings = {
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
