{
  description = "TheRealGramdalf's no-longer-experimental config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    openwrt-imagebuilder = {
      url = "github:astro/nix-openwrt-imagebuilder";
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
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    home-manager-stable,
    nixos-hardware,
    ...
  }:
  # Create convenience shorthands
  let
    stableNixosSystem = nixpkgs-stable.lib.nixosSystem;
    inherit (nixpkgs.lib) nixosSystem;
    tome = import ./lib/main.nix inputs.nixpkgs.lib;
    x86pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in {
    # To run checks on a host (i.e. `nix why-depends <host> nixpkgs#hello`), use .#nixosConfigurations.HOSTNAME.config.system.build.toplevel
    ## Dev stuff
    formatter.x86_64-linux = x86pkgs.alejandra;
    devShells.x86_64-linux = {
      "default" = x86pkgs.mkShellNoCC {
        name = "hecker";
        meta.description = "The default development shell for my NixOS configurations";
        # Enable flakes/nix3 for convenience
        NIX_CONFIG = "extra-experimental-features = nix-command flakes";
        # packages available in the dev shell
        packages = with x86pkgs; [
          alejandra # nix formatter
          git # flakes require git, and so do I
          statix # lints and suggestions
          deadnix # clean up unused nix code
          disko # Declarative disk partitioning, easier than `nix run`
          just
        ];
      };
      "klipperwrt" = x86pkgs.mkShellNoCC {
        name = "klipperwrt-firmware";
        meta.description = "Devshell with the necessary packages to build klipper firmware";
        # Instructions:
        # - Mount the SDCard from the wifi box
        # - Use `sudo -i` to become root
        # - As root, enter the shell
        # - CD to the klipper repo (upper/root/klipper)
        # - Run `make clean` to clean caches
        # - Run `make` to build the firmware
        # - Run `make flash FLASH_DEVICE=/dev/serial/by-id/<serial-id>` to flash the firmware directly
        # packages available in the dev shell
        packages = with x86pkgs; [
          python3
          pkgsCross.avr.stdenv.cc
          gcc-arm-embedded
          bintools-unwrapped
          libffi
          libusb1
          avrdude
          stm32flash
          #wxGTK32 # For bossac, whatever that is
        ];
      };
      "tasmota" = x86pkgs.mkShell {
        packages = with x86pkgs; [
          esptool
          #espflash
          #uclibc
          #zopfli
          platformio
          platformio-core
          python312
          python312Packages.pip
          python312Packages.zopfli
          python312Packages.wheel
        ];
      };
    };
    nixosConfigurations = {
      "ripjaw" = nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/ripjaw/main.nix
          ./mods/nixos/main.nix
          home-manager.nixosModules.home-manager
        ];
      };
      "aerwiar" = nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          nixos-hardware.nixosModules.framework-16-7040-amd
          ./hosts/aerwiar/main.nix
          ./mods/nixos/main.nix
          home-manager.nixosModules.home-manager
        ];
      };
      "muffin-time" = stableNixosSystem {
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
        ];
      };
      "aer" = nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit tome;
        };
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
      pkgs = x86pkgs;
    in {
      cups-brother-mfcl2700dw = pkgs.callPackage ./pkgs/cups-brother-mfcl2700dw.nix {};
      dashy-ui = pkgs.callPackage ./pkgs/dashy-ui.nix {};
      wazuh-agent = pkgs.callPackage ./pkgs/wazuh/agent {};
      wazuh-manager = pkgs.callPackage ./pkgs/wazuh/manager {};
      filedialpy = pkgs.python3Packages.callPackage ./pkgs/filedialpy.nix {};
      timekpr-webui = pkgs.python3Packages.callPackage ./pkgs/timekpr-webui.nix {python = pkgs.python313;};
      # Must be built with --option sandbox false at the moment due to platformio fetching dependencies
      #tasmota = pkgs.callPackage ./pkgs/tasmota.nix {};
      tasmota-ssl = pkgs.callPackage ./pkgs/tasmota.nix {
        userConfig = builtins.readFile ./hosts/smarthome/tasmota-tls.h;
      };
      tasmota-kuled = pkgs.callPackage ./pkgs/tasmota.nix {
        userConfig = builtins.readFile ./hosts/smarthome/kuled.h;
      };
      peetscastle = pkgs.callPackage ./hosts/peetscastle/main.nix {
        inherit inputs;
        inherit pkgs;
      };
      killridge = pkgs.callPackage ./hosts/killridge/main.nix {
        inherit inputs;
        inherit pkgs;
      };
    };
  };
}
