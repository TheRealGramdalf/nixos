{
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 10d --keep 5";
  };
  environment.sessionVariables.NH_BYPASS_ROOT_CHECK = "true";
}
