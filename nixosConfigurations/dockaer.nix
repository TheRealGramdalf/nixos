{ inputs, ... }@flakeContext:
let
  nixosModule = { config, lib, pkgs, ... }: {
    config = {
      environment = {
        systemPackages = [
          pkgs.docker
          pkgs.docker-compose
          pkgs.vim
        ];
      };
      users = {
        mutableUsers = true;
      };
      virtualisation = {
        docker = {
          enable = true;
          enableOnBoot = true;
          liveRestore = true;
          storageDriver = "overlay2";
        };
      };
    };
  };
in
inputs.nixpkgs.lib.nixosSystem {
  modules = [
    nixosModule
  ];
  system = "x86_64-linux";
}
