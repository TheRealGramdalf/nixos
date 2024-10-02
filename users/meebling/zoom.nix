{pkgs, ...}: {
  imports = [
    ./hypr/hypr.nix
  ];

  tomeutils.adhde = {
    enable = true;
    idle.sleep = true;
  };

  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };
    packages = [
      pkgs.zoom-us
    ];
  };
}
