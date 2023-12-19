{
  description = "Docker nixos LXC";
  inputs = {
    nixos-generators.url = "flake:nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "flake:nixpkgs";
    nixpkgs-2.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = inputs:
    let
      flakeContext = {
        inherit inputs;
      };
    in
    {
      nixosModules = {
        docker-ve = import ./nixosModules/docker-ve.nix flakeContext;
        gettyFix = import ./nixosModules/gettyFix.nix flakeContext;
      };
      packages = {
        x86_64-linux = {
          nix-lxc = import ./packages/nix-lxc.nix flakeContext;
        };
      };
    };
}
