{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    lsd # ls deluxe
    neovim # Text editor
    git # Version control
    sysz # Systemctl TUI
    tealdeer # TL;DR for linux commands
    comma # , Run any command from nixpkgs
  ];
  nix = {
    package = pkgs.nixVersions.nix_2_23;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
