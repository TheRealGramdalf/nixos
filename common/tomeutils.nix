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
  ];
  nix = {
    package = pkgs.nixVersions.nix_2_24;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
