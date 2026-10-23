{
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 10d --keep 5";
  };
  environment.sessionVariables = {
    NH_ASK = true;
    NH_CONTINUE_ON_ACTIVATION_FAILURE = true;
  };
}
