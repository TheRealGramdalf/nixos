{
  imports = [
    ./wezterm.nix
    ./nushell.nix
  ];
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
  };
}
