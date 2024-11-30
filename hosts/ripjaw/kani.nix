let
  mainGroup = "50bc3d3a-87cd-4e90-ac6d-fb97f9b1a051"; # ripjaw-login
in {
  services.kanidm = {
    clientSettings.uri = "https://auth.aer.dedyn.io";
    enablePam = true;
    unixSettings = {
      pam_allowed_login_groups = ["${mainGroup}"];
      kanidm = {
        map_group = [
          {
            local = "video";
            "with" = "${mainGroup}";
          }
          {
            local = "networkmanager";
            "with" = "${mainGroup}";
          }
        ];
      };
    };
  };
}