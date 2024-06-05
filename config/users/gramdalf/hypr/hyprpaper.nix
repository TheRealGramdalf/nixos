{pkgs, ...}: {
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "${./paper/DPR-mages.png}"
      ];
      wallpaper = [
        ", ${./paper/DPR-mages.png}"
      ];
    };
  };
}
