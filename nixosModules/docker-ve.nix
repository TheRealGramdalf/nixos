{ inputs, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  config = {
    environment = {
      systemPackages = [
        pkgs.vim
        pkgs.git
        pkgs.docker-compose
      ];
      variables = {
        STACKS_DIR = "/compose/stacks";
        INCLUDE_DIR = "/compose/include";
      };
    };
    networking = {
      enableIPv6 = false;
    };
    services = {
      openssh = {
        listenAddresses = [
          {
            addr = "0.0.0.0";
            port = 22;
          }
        ];
      };
      resolved = {
        enable = false;
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
        liveRestore = true;
        storageDriver = "overlay2";
      };
    };
  };
}
