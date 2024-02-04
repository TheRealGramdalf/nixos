{ inputs, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  config = {
    nix.settings = {
      # Enable rebuilding with flakes inside the LXC
      experimental-features = [ "nix-command" "flakes" ];
      # Add the nix binary cache to make builds faster
     substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        #"cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" # Included by default, trusted keys is additive
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    environment = {
      systemPackages = with pkgs; [
        neovim 
        git
        kanidm
        lsd
      ];
    };

    # Fix proxmox networking
    networking = {
      enableIPv6 = false;
      firewall.enable = true; 
      # Get DNS info from proxmox
      resolvconf.enable = false; 
  	  #^^ Might not be needed?
    };
    # DNS cache shouldn't happen in the LXC
    services.resolved.enable = false;


    services = {
      # Consume POSIX accounts from Kanidm
      kanidm = {
        enablePam = true;
        clientSettings.uri = "https://auth.aer.dedyn.io";
        unixSettings = {
          pam_allowed_login_groups = [ "dockaer-login" ];
          default_shell = "/bin/bash";
          home_prefix = "/home/";
          home_attr = "uuid";
          home_alias = "spn";
          use_etc_skel = false;
          uid_attr_map = "spn";
          gid_attr_map = "spn";
          selinux = true;
      };};

      # Network shares
      samba = {
        package = pkgs.samba4Full;
        # ^^ Needed to enable mDNS support. Thank you iv.cha! 
        # See https://github.com/NixOS/nixpkgs/blob/592047fc9e4f7b74a4dc85d1b9f5243dfe4899e3/pkgs/top-level/all-packages.nix#L27268
        enable = true;
        openFirewall = true;
        shares = {
          photos = {
            path = "/tank/photos";
            writable = "true";
            comment = "Ye Olde Photos";
          };
          media = {
            path = "/tank/media";
            writable = true;
            comment = "The Seven Seas";
          };
          nixos = {
            path = "/etc/nixos";
            writable = true;
            comment = "NixOS Configurations";
          };
          Data = {
            path = "/tank/Data";
            writable = true;
            comment = "All your mushrooms go here";
          };
        };
        extraConfig = ''
          ## Security Settings
          # Permissions
          inherit owner = unix only 
          inherit permissions = yes 
          # ^^ Overrides `create` and `force create` `mask/mode`
          # Authentication
	        passdb backend = tdbsam:/tank/samba-passdb.tdb 
          security = user 
          hosts allow = 192.168.1. 127.0.0.1
          hosts deny = ALL
          guest account = nobody 
          map to guest = Bad User
          # guest ok = true
          #//TODO Look into: `invalid users`
          # Generic
          server smb encrypt = required
          # ^^ Note: Breaks `smbclient -L <ip> -U%`
          server min protocol = SMB3_00

          ## Performance Optimizations & platform compatibility
          use sendfile = yes
        '';
      };
      avahi = {
        publish.enable = true;
        publish.userServices = true;
        # ^^ Needed for samba to automatically register mDNS records
        nssmdns4 = true;
	      enable = true;
        openFirewall = true;
	      allowInterfaces = [ "upstream0" ];
      };
      samba-wsdd = {
        enable = true;
        openFirewall = true;
        interface = "upstream0";
	      hostname = "aer-files";
      };
      openssh = {
        enable = true;
        settings.PasswordAuthentication = false;
        settings.PermitRootLogin = "prohibit-password";
        listenAddresses = [{
          addr = "0.0.0.0";
          port = 22;
      }];};
    };
    users = {
      mutableUsers = true;
      users.root.initialHashedPassword = "$y$j9T$j0JBV3iwFMEbM0TKMvqnv.$92W0gf1Jd61jl/s1DLxUSxViuKyKIW0jZ.I4q6wyDC2";
    };
  };
}
