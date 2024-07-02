{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
with lib; let
  cfg = config.tomeutils.vapor;
  gamescopeCfg = osConfig.programs.gamescope;
  #steam-gamescope = let
  #  exports = builtins.attrValues (builtins.mapAttrs (n: v: "export ${n}=${v}") cfg.gamescopeSession.env);
  #in
  #  pkgs.writeShellScriptBin "steam-gamescope" ''
  #    ${builtins.concatStringsSep "\n" exports}
  #    gamescope --steam ${toString cfg.gamescopeSession.args} -- steam -tenfoot -pipewire-dmabuf
  #  '';
  #
  #gamescopeSessionFile =
  #  (pkgs.writeTextDir "share/wayland-sessions/steam.desktop" ''
  #    [Desktop Entry]
  #    Name=Steam
  #    Comment=A digital distribution platform
  #    Exec=${steam-gamescope}/bin/steam-gamescope
  #    Type=Application
  #  '').overrideAttrs (_: { passthru.providedSessions = [ "steam" ]; });
in {
  options.tomeutils.vapor = {
    enable = mkEnableOption "steam";

    package = mkOption {
      type = types.package;
      default = pkgs.steam;
      defaultText = literalExpression "pkgs.steam";
      example = literalExpression ''
        pkgs.steam-small.override {
          extraEnv = {
            MANGOHUD = true;
            OBS_VKCAPTURE = true;
            RADV_TEX_ANISO = 16;
          };
          extraLibraries = p: with p; [
            atk
          ];
        }
      '';
      apply = steam:
        steam.override (prev: {
          extraEnv =
            (lib.optionalAttrs (cfg.extraCompatPackages != []) {
              STEAM_EXTRA_COMPAT_TOOLS_PATHS = makeSearchPathOutput "steamcompattool" "" cfg.extraCompatPackages;
            })
            // (optionalAttrs cfg.extest.enable {
              LD_PRELOAD = "${pkgs.pkgsi686Linux.extest}/lib/libextest.so";
            })
            // (prev.extraEnv or {});
          extraLibraries = pkgs: let
            prevLibs =
              if prev ? extraLibraries
              then prev.extraLibraries pkgs
              else [];
            additionalLibs = with osConfig.hardware.graphics;
              if pkgs.stdenv.hostPlatform.is64bit
              then [package] ++ extraPackages
              else [package32] ++ extraPackages32;
          in
            prevLibs ++ additionalLibs;
        });
      # // optionalAttrs (cfg.gamescopeSession.enable && gamescopeCfg.capSysNice)
      #{
      #  buildFHSEnv = pkgs.buildFHSEnv.override {
      #    # use the setuid wrapped bubblewrap
      #    bubblewrap = "${config.security.wrapperDir}/..";
      #  };
      #}
      description = ''
        The Steam package to use. Additional libraries are added from the system
        configuration to ensure graphics work properly.

        Use this option to customise the Steam package rather than adding your
        custom Steam to {option}`environment.systemPackages` yourself.
      '';
    };

    extraCompatPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      example = literalExpression ''
        with pkgs; [
          proton-ge-bin
        ]
      '';
      description = ''
        Extra packages to be used as compatibility tools for Steam on Linux. Packages will be included
        in the `STEAM_EXTRA_COMPAT_TOOLS_PATHS` environmental variable. For more information see
        https://github.com/ValveSoftware/steam-for-linux/issues/6310.

        These packages must be Steam compatibility tools that have a `steamcompattool` output.
      '';
    };

    extest.enable = mkEnableOption ''
      Load the extest library into Steam, to translate X11 input events to
      uinput events (e.g. for using Steam Input on Wayland)
    '';
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = osConfig.tomeutils.vapor.enable;
        message = "Vapor must be enabled system-wide for steam to work properly";
      }
    ];
    home.packages = [
      cfg.package
      cfg.package.run
    ];
    # ++ lib.optional cfg.gamescopeSession.enable steam-gamescope;

    #wayland.windowManager.hyprland.settings = lib.mkIf (config.wayland.windowManager.hyprland.enable) {
    #  windowrulev2 = [
    # Windowrules for steam (src: https://www.reddit.com/r/hyprland/comments/183tmfy/comment/kark334)
    #windowrule=float,^(.*.exe)$
    #windowrule=float,^(steam_app_.*)$
    #windowrule=float,^(steam_proton)$
    #  ];
    #};
  };
}
