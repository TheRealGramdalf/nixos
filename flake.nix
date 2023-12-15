{
  description = "Docker nixos LXC";
  inputs = {
    nixpkgs.url = "flake:nixpkgs/nixpkgs-unstable";
    nixos-generators.url = "flake:nixos-generators";
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
