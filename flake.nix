{
  description = "Docker nixos LXC";
  inputs = {
    nixos-generators.url = "flake:nixos-generators";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
      };
      packages = {
        x86_64-linux = {
          nix-lxc = import ./packages/nix-lxc.nix flakeContext;
        };
      };
    };
}
