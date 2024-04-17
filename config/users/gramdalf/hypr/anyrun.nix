{
  config,
  pkgs,
  lib,
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
      ];
      closeOnClick = true;
      showResultsImmediately = true;
      maxEntries = 20;
      width = {fraction = 0.3;};
    };
    extraCss = ''
      label#match-desc {
        font-size: 10px;
      }
      
      label#plugin {
        font-size: 14px;
      } 
    '';
  };
}
