{
  imports = [
    # Commonly used config
    ../../common/posix-client.nix
    ../../common/avahi-client.nix
    ../../common/zfs-boot.nix

    # Host-specific config
    ./hardware-config.nix
    ./configuration.nix
    #./home.nix
  ];
  networking = {
    hostname = "ripjaw";
    hostId = "a4ed175a";
  };
}