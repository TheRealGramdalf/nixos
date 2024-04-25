{
  imports = [
    ./zsh.nix
    ./wezterm.nix
  ];
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
  };
}