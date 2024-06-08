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
      url = "github:anyrun-org/anyrun/9e14b5946e413b87efc697946b3983d5244a1714";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    inputmodule-pr = {
      url = "github:Nixos/nixpkgs/790a99b65bc925df3b4e30d9eba03d34e8644a29";
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
          ./mods/nixos/main.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit context;};
              sharedModules = [
                ./mods/home/main.nix
              ];
              users."games" = import ./config/users/games/main.nix;
            };
            users.mutableUsers = false;
            users.users."games" = {
              isNormalUser = true;
              hashedPasswordFile = "/persist/secrets/passwdfile.games";
              extraGroups = ["video" "network"];
            };
          }
        ];
      };
      "aerwiar" = nixosSystem {
        specialArgs = {inherit context;};
        modules = [
          nixos-hardware.nixosModules.framework-16-7040-amd
          ./config/hosts/aerwiar/main.nix
          ./mods/nixos/main.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit context;};
              sharedModules = [
                ./mods/home/main.nix
              ];
              users."gramdalf" = import ./config/users/gramdalf/main.nix;
            };
            users.mutableUsers = false;
            users.users."gramdalf" = {
              isNormalUser = true;
              extraGroups = ["wheel" "video" "netdev" "docker" "adbusers" "wireshark"];
              hashedPasswordFile = "/persist/secrets/passwdfile.gramdalf";
              group = "gramdalf";
            };
            users.groups."gramdalf" = {};
          }
        ];
      };
      "atreus" = nixosSystem {
        modules = [
          ./config/hosts/atreus/main.nix
          ./mods/nixos/main.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit context;};
              sharedModules = [
                ./mods/home/main.nix
              ];
              users."meebling" = import ./config/users/meebling/main.nix;
              users."meeblingthedevilish" = import ./config/users/meebling/devilish.nix;
            };
            users.mutableUsers = false;
            users.users."meebling" = {
              isNormalUser = true;
              hashedPasswordFile = "/persist/secrets/passwdfile.meebling";
              extraGroups = ["video" "netdev"];
            };
            users.users."meeblingthedevilish" = {
              isNormalUser = true;
              hashedPasswordFile = "/persist/secrets/passwdfile.meeblingthedevilish";
              extraGroups = ["video" "netdev"];
            };
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
          ./config/hosts/docker-ve/main.nix
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
