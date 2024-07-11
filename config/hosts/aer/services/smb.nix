{pkgs, ...}: {
  services = {
    # Network shares
    samba = {
      package = pkgs.samba4Full;
      # ^^ Needed to enable mDNS support. Thank you iv.cha!
      # See https://github.com/NixOS/nixpkgs/blob/592047fc9e4f7b74a4dc85d1b9f5243dfe4899e3/pkgs/top-level/all-packages.nix#L27268
      enable = true;
      openFirewall = true;
      shares = {
        photos = {
          path = "/tank/smb/photos";
          writable = true;
          comment = "Ye Olde Photos";
        };
        media = {
          path = "/tank/media";
          writable = true;
          comment = "The Seven Seas";
        };
        Data = {
          path = "/tank/smb/Data";
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
        passdb backend = tdbsam:/tank/smb/samba-passdb.tdb
        security = user
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
    };
  };
}
