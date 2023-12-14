{ inputs, ... }@flakeContext:
let
  nixosModule = { config, lib, pkgs, ... }: {
    config = {
      environment = {
        systemPackages = [
          pkgs.docker
          pkgs.docker-compose
        ];
      };
      users = {
        mutableUsers = true;
        users = {
          root = {
            hashedPassword = '$y$j9T$
              j0JBV3iwFMEbM0TKMvqnv.$92W0gf1Jd61jl/s1DLxUSxViuKyKIW0jZ.I4q6wyDC2';
              };
              };
              };
              virtualisation = {
            docker = {
            daemon = {
            settings = {
            bridge = "none";
            ipv6 = false;
            default-address-pools = [
              {
                base = "172.30.0.0/16";
                size = 24;
              }
              {
                base = "172.31.0.0/16";
                size = 24;
              }
            ];
          };
        };
        enable = true;
        enableOnBoot = true;
        liveRestore = true;
        storageDriver = "overlay2";
      };
    };
  };
  };
  in
  inputs.nixos-generators.nixosGenerate {
  system = "x86_64-linux";
  format = "proxmox-lxc";
  modules = [
    nixosModule
  ];
  }
