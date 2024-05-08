{
  imports = [
    ./wezterm.nix
    ./nushell.nix
  ];
  programs = {
    starship = {
      enable = true;
      enableNushellIntegration = true;
    };
    ssh = {
      enable = true;
      extraConfig = ''
        IdentityFile = ~/.ssh/gramdalf-key
      '';
    };
  };
}
