{
  description = "Docker nixos LXC";
  inputs = {
    nixos-generators.url = "flake:nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = inputs:
    let
      flakeContext = {
        inherit inputs;
      };
    in
    {
      nixosConfigurations = {
        nixos-testing-lxc = import ./nixosModules/nixos-testing-lxc.nix flakeContext;
      };
      nixosModules = {
        docker-ve = import ./nixosModules/docker-ve.nix flakeContext;
        gettyFix = import ./nixosModules/gettyFix.nix flakeContext;
        nixos-testing-lxc = import ./nixosModules/nixos-testing-lxc.nix flakeContext;
      };
      packages = {
        x86_64-linux = {
          nix-lxc = import ./packages/nix-lxc.nix flakeContext;
          nix-lxc-dev = import ./packages/nix-lxc-dev.nix flakeContext;
        };
      };
    };
}
