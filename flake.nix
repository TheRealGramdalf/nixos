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
      nixosConfigurations = {
        dockaer = import ./nixosConfigurations/dockaer.nix flakeContext;
      };
      packages = {
        x86_64-linux = {
          dockaer = import ./packages/dockaer.nix flakeContext;
        };
      };
    };
}
