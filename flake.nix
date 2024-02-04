{
  description = "Proxmox LXC utils & configurations";
  nixConfig = {
    # Enable rebuilding with flakes
    experimental-features = [ "nix-command" "flakes" ];
    # Add the nix-community binary cache to make builds faster
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
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
        docker-ve = import ./nixosConfigurations/docker-ve.nix flakeContext;
        nixos-testing-lxc = import ./nixosConfigurations/nixos-testing-lxc.nix flakeContext;
        aer-files = import ./nixosConfigurations/aer-files.nix flakeContext;
        ripjaw = import ./nixosConfigurations/ripjaw.nix flakeContext;
      };
      nixosModules = {
        aer-files = import ./nixosModules/aer-files.nix flakeContext; 
        nvchad = import ./nixosModules/nvchad.nix flakeContext;
      	docker-ve = import ./nixosModules/docker-ve.nix flakeContext;
        ripjaw = import ./nixosModules/ripjaw.nix flakeContext;
        nixos-testing-lxc = import ./nixosModules/nixos-testing-lxc.nix flakeContext;
        posix-client = import ./nixosModules/posix-client.nix flakeContext;
      };
      packages = {
        x86_64-linux = {
          nix-lxc = import ./packages/nix-lxc.nix flakeContext;
          nix-lxc-dev = import ./packages/nix-lxc-dev.nix flakeContext;
          aer-files-nix-lxc = import ./packages/aer-files-nix-lxc.nix flakeContext;
        };
      };
    };
}
