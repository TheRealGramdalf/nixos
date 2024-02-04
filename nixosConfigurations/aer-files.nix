{ inputs, ... }@flakeContext:
let
  nixosModule = { config, lib, pkgs, modulesPath, ... }: {
    imports = [
      (modulesPath + "/virtualisation/proxmox-lxc.nix")
      inputs.self.nixosModules.aer-files
    ];
  };
in
inputs.nixpkgs.lib.nixosSystem {
  modules = [
    nixosModule
  ];
  system = "x86_64-linux";
}
