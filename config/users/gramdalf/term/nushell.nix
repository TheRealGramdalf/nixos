{
  pkgs,
  ...
}: {
  programs.nushell = {
    enable = true;
    package = pkgs.nushellFull;
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };
}
