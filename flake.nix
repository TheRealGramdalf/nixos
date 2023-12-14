{
  description = "Docker nixos LXC";
  inputs = {
    nixpkgs.url = "flake:nixpkgs/nixpkgs-unstable";
    nixos-generators.follows = "nixpkgs";
  };
  outputs = inputs:
    let
      flakeContext = {
        inherit inputs;
      };
    in
    {
      nixosConfigurations = {
        dockaer = import ./nixosConfigurations/dockaer.nix flakeContext;
      };
    };
}
