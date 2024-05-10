{
  description = "TheRealGramdalf's experimental config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = context @ {
    nixpkgs,
    home-manager,
    nixos-generators,
    nixos-hardware,
    ...
  }:
  # Create convenience shorthands
  let
    inherit (nixpkgs.lib) nixosSystem;
    inherit (home-manager.lib) homeManagerConfiguration;
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    nixosConfigurations = {
      "ripjaw" = nixosSystem {
        modules = [
          ./config/hosts/ripjaw/main.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit context;};
              sharedModules = [
                ./mods/home/hypr/hyprkeys.nix
              ];
              users."games" = import ./config/users/games/main.nix;
            };
            users.users."games".isNormalUser = true;
          }
        ];
      };
      "aerwiar" = nixosSystem {
        modules = [
          nixos-hardware.nixosModules.framework-16-7040-amd
          ./config/hosts/aerwiar/main.nix
        ];
      };
      "atreus" = nixosSystem {
        modules = [
          ./config/hosts/atreus/main.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit context;};
              sharedModules = [
                ./mods/home/hypr/hyprkeys.nix
              ];
              users."meebling" = import ./config/users/meebling/main.nix;
              users."meeblingthedevilish" = import ./config/users/meebling/devilish.nix;
            };
            users.users."meebling".isNormalUser = true;
            users.users."meeblingthedevilish".isNormalUser = true;
          }
        ];
      };
      "aer-files" = nixosSystem {
        modules = [
          ./config/hosts/aer-files/main.nix
        ];
      };
      "docker-ve" = nixosSystem {
        modules = [
          ./config/hosts/aerwiar/main.nix
        ];
      };
    };
    homeConfigurations = {
      "gramdalf" = homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        #useGlobalPkgs = true;
        extraSpecialArgs = {inherit context;};
        modules = [
          ./config/users/gramdalf/main.nix
        ];
      };
    };
  };

  # Global nix.settings, these are presented to the user as an optional choice on rebuild
  nixConfig = {
    # Enable rebuilding with flakes
    experimental-features = ["nix-command" "flakes"];
    # Add the nix-community binary cache to make builds faster
    # See https://nixos.org/manual/nix/stable/command-ref/conf-file.html?highlight=you%20can%20prefix%20the%20name%20of%20the%20setting%20by%20extra-%20to%20append%20to%20the%20previous%20value#file-format
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
