{pkgs, ...}: {
  imports = [
    ./hypr/hypr.nix
  ];

  tomeutils.adhde = {
    enable = true;
    idle.sleep = true;
  };

  home = {
    stateVersion = "24.05";
    sessionVariables = {
      EDITOR = "nvim";
    };
    packages = [
      pkgs.zoom-us
    ];
  };
}
