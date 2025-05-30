{pkgs, ...}: {
  services = {
    # Network shares
    samba = {
      package = pkgs.samba4.override {enableMDNS = true;};
      # ^^ Needed to enable mDNS support. Thank you iv.cha!
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          ## Security Settings
          # Permissions
          "inherit owner" = "unix only";
          "inherit permissions" = "yes";
          # ^^ Overrides `create` and `force create` `mask/mode`

          # Authentication
          "passdb backend" = "tdbsam:/tank/smb/samba-passdb.tdb";
          security = "user";
          "guest account" = "nobody";
          "map to guest" = "Bad User";

          # Generic
          "server smb encrypt" = "required";
          # ^^ Note: Breaks `smbclient -L <ip> -U%`
          "server min protocol" = "SMB3_00";

          ## Performance Optimizations & platform compatibility
          "use sendfile" = "yes";
          # Let avahi choose the hostname to broadcast as
          # This should fix an issue where windows refuses to mount a share
          # due to the hostname being capitalized by default, which isn't advertised
          "mdns name" = "mdns";
        };
        "photos" = {
          path = "/tank/smb/photos";
          writable = true;
          comment = "Ye Olde Photos";
        };
        "media" = {
          path = "/tank/media";
          writable = true;
          comment = "The Seven Seas";
        };
        "Data" = {
          path = "/tank/smb/Data";
          writable = true;
          comment = "All your mushrooms go here";
        };
      };
    };
    avahi = {
      publish.enable = true;
      publish.userServices = true;
      # ^^ Needed for samba to automatically register mDNS records
    };
  };
}
