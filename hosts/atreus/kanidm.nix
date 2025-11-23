{pkgs, ...}: let
  mainGroup = "0359756e-7db7-410a-bc16-89621465f64a"; # atreus-login
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
          {
            local = "timekpr";
            "with" = "fd5a9395-68f4-42d6-a7f2-c64fd1f13e96";
          }
          {
            local = "wheel";
            "with" = "fd5a9395-68f4-42d6-a7f2-c64fd1f13e96";
          }
        ];
      };
    };
  };
}
