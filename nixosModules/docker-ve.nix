{ inputs, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  config = {
    # Patches for running inside an LXC container
    systemd.mounts = [{
      where = "/sys/kernel/debug";
      enable = false;
    }];
    boot.isContainer = true;

  
    nix.settings = {
      # Enable rebuilding with flakes inside the LXC
      experimental-features = [ "nix-command" "flakes" ];
      # Add the nix binary cache to make builds faster
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "binarycache.example.com-1:dsafdafDFW123fdasfa123124FADSAD"
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    environment = {
      systemPackages = with pkgs; [
        vim
        git
        docker-compose
        lazydocker
        tcpdump
        kanidm
        samba
      ];
      variables = {
        STACKS_DIR = "/compose/stacks";
        INCLUDE_DIR = "/compose/include";
        MEDIA_DIR = "/tank/media";
        FQDN = "aer.dedyn.io";
        AUTH_BASE_URL = "https://auth.aer.dedyn.io"; 
        AUTH_UI_URL = ''''${AUTH_BASE_URL}/ui/oauth2''; # Don't interpolate the base url with nix
        AUTH_TOKEN_URL = ''''${AUTH_BASE_URL}/oauth2/token''; # ^^
    };};

    # Fix proxmox networking
    networking = {
      enableIPv6 = false;
      # lxc-level firewall coming soon™
      firewall.enable = false;

      # Get DNS info from proxmox
      resolvconf.enable = false;
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
        enable = false;
        shares.photos = {
          path = "/tank/photos";
          "read only" = false;
          browseable = "yes";
          "guest ok" = "no";
          comment = "Ye Olde Photos";
        };
        extraConfig = ''
        [global]
          inherit owner = unix only ; Inherit ownership of the parent directory for new files and directories
          inherit permissions = yes ; Inherit permissions of the parent directory for new files and directories
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
      avahi.enable = false;

      openssh = {
        enable = true;
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
    # Docker daemon settings
    virtualisation.docker.daemon.settings = {
      bridge = "none";
      ipv6 = false;
      default-address-pools = [{
          base = "172.30.0.0/16";
          size = 24;
        }
        {
          base = "172.31.0.0/16";
          size = 24;
      }];
    };
    virtualisation.docker = {
      enable = true;
      liveRestore = true;
      storageDriver = "overlay2";
    };
  };
}
