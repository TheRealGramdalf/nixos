{
  config,
  pkgs,
  context,
  ...
}: {
  imports = [
    context.anyrun.homeManagerModules.default
  ];
  programs.anyrun = {
    enable = true;
    config = {
      plugins = with context.anyrun.packages.${pkgs.system}; [
        applications
        rink
        symbols
        randr
      ];
      closeOnClick = false;
      showResultsImmediately = false;
      maxEntries = 20;
      width.fraction = 0.3;
      x.fraction = 0.5;
      y.fraction = 0.1;
    };
    extraCss = ''
      label#match-desc {
        font-size: 10px;
      }

      label#plugin {
        font-size: 14px;
      }
      #window {
        background-color = transparent;
      }
    '';
  };
}
