{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib.types) package str;
  inherit (lib) mkIf mkOption mkEnableOption mkPackageOption;
  cfg = config.services.dashy;
in {
  options.services.dashy = {
    enable = mkEnableOption "Dashy, a highly customizable, easy to use, privacy-respecting dashboard app";

    virtualHost = {
      enableNginx = mkEnableOption "a virtualhost to serve dashy through nginx";
      domain = mkOption {
        description = ''
          Domain to use for the virtual host
        '';
        type = str;
      };
      #config = mkOption {
      #  description = ''
      #    Alias to the virtualhost config in use
      #  '';
      #};
    };

    package = mkPackageOption inputs.self.packages.x86_64-linux "dashy-ui" {};
    finalDrv = mkOption {
      readOnly = true;
      default =
        if cfg.settings != {}
        then cfg.package.override {inherit (cfg) settings;}
        else cfg.package;
      defaultText = ''
        if cfg.settings != {}
        then cfg.package.override {inherit (cfg) settings;}
        else cfg.package;
      '';
      type = package;
      description = ''
        Final derivation containing the fully built static files
      '';
    };

    settings = mkOption {
      default = {};
      description = ''
        Settings serialized into `user-data/conf.yml` before build.
        If left empty, the default configuration shipped with the package will be used instead
      '';
      inherit (pkgs.formats.json {}) type;
    };
    #pages = mkOption {
    #  default = {};
    #  description = ''
    #  '';
    #  type = submodule;
    #};
  };

  config = mkIf cfg.enable {
    services.nginx = mkIf cfg.virtualHost.enableNginx {
      enable = true;
      virtualHosts."${cfg.virtualHost.domain}" = {
        locations = {
          "/" = {
            root = cfg.finalDrv;
            tryFiles = "$uri /index.html ";
          };
        };
      };
    };
  };
}
