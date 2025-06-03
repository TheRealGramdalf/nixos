{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  # Target minecraft version
  mcVersion = "1.21.5";
  fabricVersion = "0.16.14";
  # Format minecraft version, replacing . with _
  serverVersion = lib.replaceStrings ["."] ["_"] "fabric-${mcVersion}";
in {
  imports = [inputs.nix-minecraft.nixosModules.minecraft-servers];
  nixpkgs.overlays = [inputs.nix-minecraft.overlay];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    dataDir = "/persist/services/minecraft";
    servers."nixcraft" = {
      enable = false;
      package = pkgs.fabricServers.${serverVersion}.override {loaderVersion = fabricVersion;};
      jvmOpts = "-Xms6144M -Xmx8192M";
      serverProperties = {
        white-list = true;
        server-port = 25565;
        motd = "Minecraft server with lots of dedicated wam";
        gamemode = "survival";
        spawn-protection = 0;
        simulation-distance = 8;
        view-distance = 10;
        level-seed = "4399847819543582427";
      };
      #symlinks = {
      #  # List all mods to be installed
      #  mods = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {
      #    # To get mods declaratively, use `nix run github:Infinidoge/nix-minecraft#nix-modrinth-prefetch -- versionid`
      #  });
      #};
    };
  };
}