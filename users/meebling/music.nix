{pkgs, ...}: {
  imports = [./kde-common.nix];
  home = {
    stateVersion = "24.05";
    sessionVariables = {
      EDITOR = "nvim";
    };
    packages = [
      pkgs.spotube
    ];
  };
}
