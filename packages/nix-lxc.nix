{ inputs, ... }@flakeContext:
let
  nixosModule = { config, lib, pkgs, ... }: {
    imports = [
      inputs.self.nixosModules.docker-ve
      inputs.self.nixosModules.gettyFix
    ];
    config = {
      services = {
        openssh = {
          settings = {
            PermitRootLogin = "prohibit-password";
          };
        };
        sshd = {
          enable = true;
        };
      };
      system = {
        stateVersion = "23.11";
      };
      users = {
        mutableUsers = true;
        users = {
          root = {
            hashedPassword = "$y$j9T$j0JBV3iwFMEbM0TKMvqnv.$92W0gf1Jd61jl/s1DLxUSxViuKyKIW0jZ.I4q6wyDC2";
          };
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
