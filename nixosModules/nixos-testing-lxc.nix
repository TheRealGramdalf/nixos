{ inputs, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  config = {
    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
    environment = {
      systemPackages = with pkgs; [
        vim
        git
      ];
    };
    networking = {
      enableIPv6 = false;
      firewall = {
        enable = false;
      };
      resolvconf = {
        enable = false;
      };
    };
    services = {
      #avahi.enable = true;
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
  };
}
