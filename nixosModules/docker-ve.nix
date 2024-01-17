{ inputs, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  config = {
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
      };
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
      kanidm = {
        enablePam = true;
        clientSettings = {
          uri = "https://auth.aer.dedyn.io";
        };
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
        };
      };
      samba = {
        enable = true;
        shares = {
          photos = {
            path = "/tank/photos";
            "read only" = false;
            browseable = "yes";
            "guest ok" = "no";
            comment = "Ye Olde Photos";
          };
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
        ''
      };
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
