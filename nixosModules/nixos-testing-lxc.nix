{ inputs, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  config = {
    # Patches for running inside an LXC container
    systemd.mounts = [{
      where = "/sys/kernel/debug";
      enable = false;
    }];
    boot.isContainer = true;

    # Enable rebuilding with flakes inside the LXC
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    environment = {
      systemPackages = with pkgs; [
        vim
        git
      ];
    };

    # Fix proxmox networking
    networking = {
      enableIPv6 = false;
      firewall = {
        enable = false;
      };
      # Let proxmox overwrite DNS entries
      resolvconf = {
        enable = false;
      };
    };
    services = {
      # Disable DNS cache, this is managed elsewhere
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
