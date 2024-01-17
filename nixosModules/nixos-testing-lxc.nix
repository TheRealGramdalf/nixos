{ inputs, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  config = {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
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
      resolved = {
        enable = false;
      };
      openssh = {
        settings = {
          PermitRootLogin = "prohibit-password";
        };
        listenAddresses = [
          {
            addr = "0.0.0.0";
            port = 22;
          }
        ];
      };
      sshd.enable = true;
      #avahi.enable = true;
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
}
