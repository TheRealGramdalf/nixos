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
        vim
        git
        docker-compose
        lazydocker
	      dive
        tcpdump
        kanidm
        iperf3
        traceroute
        samba
      ];
    };

    # Fix proxmox networking
    networking = {
      enableIPv6 = false;
      # lxc-level firewall coming soon™
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
        enable = true;
        openFirewall = true;
        shares.photos = {
          path = "/tank/photos";
          "read only" = false;
          browseable = "yes";
          "guest ok" = "no";
          comment = "Ye Olde Photos";
        };
        #; Inherit ownership of the parent directory for new files and directories
        #; Inherit permissions of the parent directory for new files and directories
        extraConfig = ''
        [global]
	        passdb backend = tdbsam:/compose/stacks/kanidm/smb/passdb.tdb 
          inherit owner = unix only 
          inherit permissions = yes
          create mask = 0664
          directory mask = 2755
          force create mode = 0644
          force directory mode = 2755
          workgroup = AERWIAR
          server string = samba-aer
          netbios name = samba-aer
          security = user 
          #use sendfile = yes
          server min protocol = SMB3_00
          # note: localhost is the ipv6 localhost ::1
          hosts allow = 192.168.1.0 127.0.0.1
          hosts deny = 0.0.0.0/0
          guest account = nobody
          map to guest = bad user
        '';
      };
      avahi = {
	      enable = true;
        openFirewall = true;
	      hostName = "AER";
	      allowInterfaces = [ "upstream0" ];
      };
      samba-wsdd = {
        enable = true;
        interface = "upstream0";
	      hostname = "AER";
      };

      openssh = {
        enable = false;
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
