{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkOption mkEnableOption literalExpression optionalAttrs optional optionals mkIf;
  inherit (lib) types;
  cfg = config.tomeutils.vapor;
  oscfg = osConfig.tomeutils.vapor;
  gamescopeCfg = osConfig.programs.gamescope;
  extraCompatPaths = lib.makeSearchPathOutput "steamcompattool" "" oscfg.extraCompatPackages;

  steam-gamescope = let
    exports = builtins.attrValues (builtins.mapAttrs (n: v: "export ${n}=${v}") oscfg.gamescopeSession.env);
  in
    pkgs.writeShellScriptBin "steam-gamescope" ''
      ${builtins.concatStringsSep "\n" exports}
      gamescope --steam ${toString oscfg.gamescopeSession.args} -- steam ${builtins.toString oscfg.gamescopeSession.steamArgs}
    '';
in {
  options.tomeutils.vapor = {
    enable = mkEnableOption "steam";
  };
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = osConfig.tomeutils.vapor.enable;
        message = "Vapor must be enabled system-wide for steam to work properly";
      }
    ];

    home.packages =
      [
        oscfg.package
        oscfg.package.run
      ]
      ++ lib.optional oscfg.gamescopeSession.enable steam-gamescope
      ++ lib.optional oscfg.protontricks.enable (
        oscfg.protontricks.package.override {inherit extraCompatPaths;}
      );
  };
}
