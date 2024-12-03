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
    minegrub-theme = {
      url = "github:Lxtharia/minegrub-world-sel-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    nixos-hardware,
    ...
  }:
  # Create convenience shorthands
  let
    inherit (nixpkgs.lib) nixosSystem;
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
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/ripjaw/main.nix
          ./mods/nixos/main.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs;};
              sharedModules = [
                ./mods/home/main.nix
              ];
              users."games" = import ./users/games/main.nix;
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
        specialArgs = {inherit inputs;};
        modules = [
          nixos-hardware.nixosModules.framework-16-7040-amd
          ./hosts/aerwiar/main.nix
          ./mods/nixos/main.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs;};
              sharedModules = [
                ./mods/home/main.nix
              ];
              users."gramdalf" = import ./users/gramdalf/main.nix;
            };
            users.mutableUsers = false;
            users.users."gramdalf" = {
              isNormalUser = true;
              extraGroups = ["wheel" "video" "netdev" "docker" "adbusers" "plugdev" "wireshark"];
              hashedPasswordFile = "/persist/secrets/passwdfile.gramdalf";
              group = "gramdalf";
            };
            users.groups."gramdalf" = {};
          }
        ];
      };
      "muffin-time" = nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen1
          ./hosts/muffin-time/main.nix
        ];
      };
      "atreus" = nixosSystem {
        modules = [
          ./hosts/atreus/main.nix
          ./mods/nixos/main.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs;};
              sharedModules = [
                ./mods/home/main.nix
              ];
              users."meebling" = import ./users/meebling/main.nix;
              users."meeblingthedevilish" = import ./users/meebling/devilish.nix;
              users."zoom" = import ./users/meebling/zoom.nix;
              users."music" = import ./users/meebling/music.nix;
            };
            users.mutableUsers = false;
            users.users."meebling" = {
              isNormalUser = true;
              hashedPasswordFile = "/persist/secrets/passwdfile.meebling";
              extraGroups = ["video" "networkmanager"];
            };
            users.users."meeblingthedevilish" = {
              isNormalUser = true;
              hashedPasswordFile = "/persist/secrets/passwdfile.meeblingthedevilish";
              extraGroups = ["video" "networkmanager"];
            };
            users.users."zoom" = {
              isNormalUser = true;
              hashedPasswordFile = "/persist/secrets/passwdfile.meeblingthedevilish";
              extraGroups = ["video" "networkmanager"];
            };
            users.users."music" = {
              isNormalUser = true;
              hashedPasswordFile = "/persist/secrets/passwdfile.meeblingthedevilish";
              extraGroups = ["video" "networkmanager"];
            };
          }
        ];
      };
      "aer" = nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/aer/main.nix
          ./mods/nixos/main.nix
        ];
      };
      "orthanc" = nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/orthanc/main.nix
          ./mods/nixos/main.nix
        ];
      };
      "iso" = nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./common/tomeutils.nix
          ({modulesPath, ...}: {
            imports = [
              "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
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
    packages.x86_64-linux = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      dashy-ui = pkgs.callPackage ./pkgs/dashy-ui.nix {};
    };
  };
}
