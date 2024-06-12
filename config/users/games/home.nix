{pkgs, ...}: {
  imports = [
    ./hypr/hypr.nix
    ./firefox.nix
  ];

  tomeutils.adhde = {
    enable = true;
    hypridle.sleep = true;
  };
  
  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };
    packages = with pkgs; [
      drawing
      gnome.nautilus
    ];
  };
  programs = {
    bash.enable = true;
  };
}
