{pkgs, ...}: {
  # Create smb user
  users = {
    groups."smb".gid = 1000;
    users."smb" = {
      uid = 1000;
      group = "smb";
      description = "SMB share user";
      isNormalUser = true;
    };
  };

  services = {
    samba = {
      enable = true;
      package = pkgs.samba4Full;
      # ^^ Needed to enable mDNS support. Thank you iv.cha!
      # See https://github.com/NixOS/nixpkgs/blob/592047fc9e4f7b74a4dc85d1b9f5243dfe4899e3/pkgs/top-level/all-packages.nix#L27268
      openFirewall = true;
      shares = {
        "data" = {
          path = "/data";
          writable = true;
          "guest ok" = true;
          comment = "Hamms' Server Data";
        };
      };
      extraConfig = ''
        ## Security Settings
        # Permissions
        inherit owner = unix only
        inherit permissions = yes
        # ^^ Overrides `create` and `force create` `mask/mode`

        # Authentication
        security = user
        guest account = smb
        guest ok = true
        map to guest = Bad User

        # Generic
        server role = standalone

        ## Performance Optimizations & platform compatibility
        use sendfile = yes
      '';
    };
    avahi = {
      publish.enable = true;
      publish.userServices = true;
      # ^^ Needed for samba to automatically register mDNS records
    };
  };
}
