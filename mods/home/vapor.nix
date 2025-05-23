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
  #steam-gamescope = let
  #  exports = builtins.attrValues (builtins.mapAttrs (n: v: "export ${n}=${v}") cfg.gamescopeSession.env);
  #in
  #  pkgs.writeShellScriptBin "steam-gamescope" ''
  #    ${builtins.concatStringsSep "\n" exports}
  #    gamescope --steam ${toString cfg.gamescopeSession.args} -- steam -tenfoot -pipewire-dmabuf
  #  '';
  #
  #gamescopeSessionFile = (pkgs.writeTextDir "share/wayland-sessions/steam.desktop" ''
  #  [Desktop Entry]
  #  Name=Steam
  #  Comment=A digital distribution platform
  #  Exec=${steam-gamescope}/bin/steam-gamescope
  #  Type=Application
  #'')
  #.overrideAttrs (_: {passthru.providedSessions = ["steam"];});
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
  #wayland.windowManager.hyprland.settings = lib.mkIf (config.wayland.windowManager.hyprland.enable) {
  #  windowrulev2 = [
  # Windowrules for steam (src: https://www.reddit.com/r/hyprland/comments/183tmfy/comment/kark334)
  #windowrule=float,^(.*.exe)$
  #windowrule=float,^(steam_app_.*)$
  #windowrule=float,^(steam_proton)$
  #  ];
  #};
}
