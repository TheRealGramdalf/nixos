{pkgs, ...}: {
  home = {
    stateVersion = "24.05";
    sessionVariables = {
      EDITOR = "nvim";
    };
    packages = [
      pkgs.thunderbird
      pkgs.zoom-us
    ];
  };
}
