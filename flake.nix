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
  };

  outputs = context @ {
    nixpkgs,
    home-manager,
    nixos-hardware,
    ...
  }:
  # Create convenience shorthands
  let
    inherit (nixpkgs.lib) nixosSystem;
    inherit (home-manager.lib) homeManagerConfiguration;
  in {
    ## Dev stuff
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShellNoCC {
      name = "hecker";
      meta.description = "The default development shell for my NixOS configurations";
      # Enable flakes/nix3 for convenience
      NIX_CONFIG = "extra-experimental-features = nix-command flakes";
      # packages available in the dev shell
      packages = with nixpkgs.legacyPackages.x86_64-linux; [
        alejandra # nix formatter
        git # flakes require git, and so do I
        statix # lints and suggestions
        deadnix # clean up unused nix code
        disko # Declarative disk partitioning, easier than `nix run`
        just
      ];
    };
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
      "aer" = nixosSystem {
        modules = [
          ./config/hosts/aer/main.nix
          ./mods/nixos/main.nix
        ];
      };
      "aer-test" = nixosSystem {
        modules = [
          ./config/hosts/aer/main.nix
          ./config/hosts/aer/vm.nix
          ./mods/nixos/main.nix
        ];
      };
      "here-nor-there" = nixosSystem {
        modules = [
          ./config/hosts/here-nor-there/main.nix
        ];
      };
      "iso" = nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./config/common/nix3.nix
          ({
            pkgs,
            modulesPath,
            ...
          }: {
            imports = [
              "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
            ];
            environment.systemPackages = with pkgs; [
              neovim
              git
            ];
            users.users."root".openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL5ibKzd+V2eR1vmvBAfSWcZmPB8zUYFMAN3FS6xY9ma"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKkR0w0kYy8ad6ulnF9o7ULZXOMy7kOdoxXzTEi5dqcq"
            ];
            services.openssh.openFirewall = true;
          })
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
    packages.x86_64-linux = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      dashy-ui = pkgs.callPackage ./pkgs/dashy-ui.nix {};
    };
  };
}
