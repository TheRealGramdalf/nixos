{
  imports = [
    ../../common/posix-client.nix
    ../../common/avahi-client.nix
    ../../common/zfs-boot.nix
  ];
  networking = {
    hostname = "ripjaw";
    hostId = "";
  };
}