{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./networking.nix
    ./hardware.nix
    ./smb.nix
    ./ssh.nix
    ./netbird.nix
  ];
  # Enable rebuilding with flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";
  networking = {
    hostName = "here-nor-there";
    hostId = "8425e349";
  };

  environment.systemPackages = with pkgs; [
    git
    sysz
    neovim
    btop
  ];
}
