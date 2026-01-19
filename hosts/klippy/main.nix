{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./networking.nix
    ./hardware.nix
    ./ssh.nix
    ../../common/tomeutils.nix
    ./system.nix
  ];
  boot.kernelPackages = pkgs.linuxPackages_6_18;
  boot.zfs.package = pkgs.zfs_2_4;
  time.timeZone = "America/Vancouver";
  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";
  networking = {
    hostName = "klippy";
    hostId = "0593d40c";
  };

  environment.systemPackages = with pkgs; [
    git
    sysz
    neovim
    tmux # Detached shell sessions
    smartmontools # SMART monitoring for block devices
  ];
}
