{
  description = "Docker nixos LXC";
  inputs = {
    nixpkgs.url = "flake:nixpkgs/nixpkgs-unstable";
    nixos-generators.url = "github:nix-community/nixos-generators";
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
