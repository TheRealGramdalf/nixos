{
  description = "TheRealGramdalf's experimental config";
  inputs = {
    nixpkgs = {
      # See https://mynixos.com/nixpkgs/options/nixpkgs
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    # ^^ Todo if needed

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #anyrun = {
    #  url = "github:anyrun-org/anyrun";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    #hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = context@{ nixpkgs, home-manager, nixos-generators, ... }:

  # Create convenience shorthands
  let
    # 
    inherit (nixpkgs.lib) nixosSystem;
    inherit (home-manager.lib) homeManagerConfiguration;
  in
  {
    nixosConfigurations = {
      "ripjaw" = nixosSystem {
        modules = [
          ./config/hosts/ripjaw/main.nix
          #home-manager.nixosModules.home-manager
      ];};
      "aerwiar" = nixosSystem {
        modules = [
          ./config/hosts/aerwiar/main.nix
      ];};
      "atreus" = nixosSystem {
        modules = [
          ./config/hosts/atreus/main.nix
      ];};
      "aer-files" = nixosSystem {
        modules = [
          ./config/hosts/aer-files/main.nix
      ];};
      "docker-ve" = nixosSystem {
        modules = [
          ./config/hosts/aerwiar/main.nix
          #home-manager.nixosModules.home-manager
      ];};
    };
    homeConfigurations = {
      "gramdalf" = homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit context; };
        modules = [
          ./config/users/gramdalf/home.nix
        ];
      };
    };
  };

  # Global nix.settings, these are presented to the user as an optional choice on rebuild
  nixConfig = {
    # Enable rebuilding with flakes
    experimental-features = [ "nix-command" "flakes" ];
    # Add the nix-community binary cache to make builds faster
    # See https://nixos.org/manual/nix/stable/command-ref/conf-file.html?highlight=you%20can%20prefix%20the%20name%20of%20the%20setting%20by%20extra-%20to%20append%20to%20the%20previous%20value#file-format
    extra-substituters = [
      "https://nix-community.cachix.org"
      #"https://hyprland.cachix.org"
    ];
    
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      #"hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
}
