{
  config,
  ...
}: {
  imports = [
    # Commonly used config
    ../../common/posix-client.nix
    ../../common/lan.nix
    ../../common/zfs-boot.nix
    ../../common/pipewire.nix
    ../../common/tomeutils.nix
    ../../common/fonts.nix
    ../../common/hypr/hypr.nix
    ../../common/nh.nix

    # Host-specific config
    ./hardware-config.nix
    ./configuration.nix
    ./arm.nix
  ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";
  networking = {
    hostName = "ripjaw";
    hostId = "a4ed175a";
  };
}
