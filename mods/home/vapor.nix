{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkOption mkEnableOption literalExpression optionalAttrs optional optionals mkIf mkDefault;
  inherit (lib) types;
  cfg = config.tomeutils.vapor;
  gamescopeCfg = osConfig.programs.gamescope;

  extraCompatPaths = lib.makeSearchPathOutput "steamcompattool" "" cfg.extraCompatPackages;
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
            (optionalAttrs (cfg.extraCompatPackages != []) {
              STEAM_EXTRA_COMPAT_TOOLS_PATHS = extraCompatPaths;
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
          extraPkgs = p: (cfg.extraPackages ++ optionals (prev ? extraPkgs) (prev.extraPkgs p));
        });
      #// optionalAttrs (cfg.gamescopeSession.enable && gamescopeCfg.capSysNice)
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

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      example = literalExpression ''
        with pkgs; [
          gamescope
        ]
      '';
      description = ''
        Additional packages to add to the Steam environment.
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

    fontPackages = mkOption {
      type = types.listOf types.package;
      # `fonts.packages` is a list of paths now, filter out which are not packages
      default = builtins.filter types.package.check osConfig.fonts.packages;
      defaultText = literalExpression "builtins.filter types.package.check osConfig.fonts.packages";
      example = literalExpression "with pkgs; [ source-han-sans ]";
      description = ''
        Font packages to use in Steam.

        Defaults to system fonts, but could be overridden to use other fonts — useful for users who would like to customize CJK fonts used in Steam. According to the [upstream issue](https://github.com/ValveSoftware/steam-for-linux/issues/10422#issuecomment-1944396010), Steam only follows the per-user fontconfig configuration.
      '';
    };

    extest.enable = mkEnableOption ''
      Load the extest library into Steam, to translate X11 input events to
      uinput events (e.g. for using Steam Input on Wayland)
    '';

    protontricks = {
      enable = mkEnableOption "protontricks, a simple wrapper for running Winetricks commands for Proton-enabled games";
      package = lib.mkPackageOption pkgs "protontricks" {};
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = osConfig.tomeutils.vapor.enable;
        message = "Vapor must be enabled system-wide for steam to work properly";
      }
    ];
    tomeutils.vapor.extraPackages = cfg.fontPackages;

    home.packages =
      [
        cfg.package
        cfg.package.run
      ]
      #++ optional cfg.gamescopeSession.enable steam-gamescope
      ++ optional cfg.protontricks.enable (cfg.protontricks.package.override {inherit extraCompatPaths;});

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
