{pkgs, ...}: let
  mainGroup = "50bc3d3a-87cd-4e90-ac6d-fb97f9b1a051"; # ripjaw-login
in {
  services.kanidm = {
    package = pkgs.kanidm_1_8;
    clientSettings.uri = "https://auth.aer.dedyn.io";
    enablePam = true;
    unixSettings = {
      # Make this empty to fix nix evaluation
      pam_allowed_login_groups = [];
      version = "2";
      kanidm = {
        # In version 2, this is under `kanidm`
        pam_allowed_login_groups = ["${mainGroup}"];
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
