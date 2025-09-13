{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    lsd # ls deluxe
    neovim # Text editor
    git # Version control
    sysz # Systemctl TUI
    tealdeer # TL;DR for linux commands
    comma # , Run any command from nixpkgs
    tmux # Run detached shell sessions
    btop # System stats
    nix-tree # See where nix closure size goes
    unzip # Good to have in general
  ];
  nix = {
    package = pkgs.nixVersions.nix_2_28;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
