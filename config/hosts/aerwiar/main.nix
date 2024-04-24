{
  config,
  ...
}: {
  imports = [
    # Commonly used config
    ../../common/zfs-boot.nix
    ../../common/pipewire.nix
    ../../common/tomeutils.nix
    ../../common/nh.nix
    ../../common/hypr/hypr.nix
    ../../common/lan.nix

    # Host-specific config
    ./hardware-config.nix
    ./configuration.nix
    ./framework.nix
  ];
  system.stateVersion = "24.05";
  nixpkgs.config.allowUnfree = true;
  networking = {
    hostName = "aerwiar";
    hostId = "16a85224";
  };
}
