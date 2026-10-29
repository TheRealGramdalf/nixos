{
  programs.nushell = {
    enable = true;
    ## STATEVERSION
    loadSessionVariables = true;
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };
}
