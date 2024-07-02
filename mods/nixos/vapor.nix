{
  config,
  lib,
  pkgs,
  ...
}:
# TODO Needs updating due to opengl cleanup
with lib; let
  cfg = config.tomeutils.vapor;
  gamescopeCfg = config.programs.gamescope;

  steam-gamescope = let
    exports = builtins.attrValues (builtins.mapAttrs (n: v: "export ${n}=${v}") cfg.gamescopeSession.env);
  in
    pkgs.writeShellScriptBin "steam-gamescope" ''
      ${builtins.concatStringsSep "\n" exports}
      gamescope --steam ${toString cfg.gamescopeSession.args} -- steam -tenfoot -pipewire-dmabuf
    '';

  gamescopeSessionFile =
    (pkgs.writeTextDir "share/wayland-sessions/steam.desktop" ''
      [Desktop Entry]
      Name=Steam
      Comment=A digital distribution platform
      Exec=${steam-gamescope}/bin/steam-gamescope
      Type=Application
    '')
    .overrideAttrs (_: {passthru.providedSessions = ["steam"];});
in {
  options.tomeutils.vapor = {
    enable = mkEnableOption "system-wide support for steam in userspace";

    remotePlay.openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Open ports in the firewall for Steam Remote Play.
      '';
    };

    dedicatedServer.openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Open ports in the firewall for Source Dedicated Server.
      '';
    };

    localNetworkGameTransfers.openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Open ports in the firewall for Steam Local Network Game Transfers.
      '';
    };

    gamescopeSession = mkOption {
      description = "Run a GameScope driven Steam session from your display-manager";
      default = {};
      type = types.submodule {
        options = {
          enable = mkEnableOption "GameScope Session";
          args = mkOption {
            type = types.listOf types.str;
            default = [];
            description = ''
              Arguments to be passed to GameScope for the session.
            '';
          };

          env = mkOption {
            type = types.attrsOf types.str;
            default = {};
            description = ''
              Environmental variables to be passed to GameScope for the session.
            '';
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    hardware.graphics = {
      # this fixes the "glXChooseVisual failed" bug, context: https://github.com/NixOS/nixpkgs/issues/47932
      enable = true;
      enable32Bit = true;
    };
    hardware.steam-hardware.enable = true;

    security.wrappers = mkIf (cfg.gamescopeSession.enable && gamescopeCfg.capSysNice) {
      # needed or steam fails
      bwrap = {
        owner = "root";
        group = "root";
        source = "${pkgs.bubblewrap}/bin/bwrap";
        setuid = true;
      };
    };
    # optionally enable 32bit pulseaudio support if pulseaudio is enabled
    hardware.pulseaudio.support32Bit = config.hardware.pulseaudio.enable;

    programs.gamescope.enable = mkDefault cfg.gamescopeSession.enable;
    services.displayManager.sessionPackages = mkIf cfg.gamescopeSession.enable [gamescopeSessionFile];

    networking.firewall = lib.mkMerge [
      (mkIf (cfg.remotePlay.openFirewall || cfg.localNetworkGameTransfers.openFirewall) {
        allowedUDPPorts = [27036]; # Peer discovery
      })

      (mkIf cfg.remotePlay.openFirewall {
        allowedTCPPorts = [27036];
        allowedUDPPortRanges = [
          {
            from = 27031;
            to = 27035;
          }
        ];
      })

      (mkIf cfg.dedicatedServer.openFirewall {
        allowedTCPPorts = [27015]; # SRCDS Rcon port
        allowedUDPPorts = [27015]; # Gameplay traffic
      })

      (mkIf cfg.localNetworkGameTransfers.openFirewall {
        allowedTCPPorts = [27040]; # Data transfers
      })
    ];
  };
}
