{
  pkgs,
  ...
}: {
  imports = [
    ./hypr/hypr.nix
    ./firefox.nix
  ];
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
