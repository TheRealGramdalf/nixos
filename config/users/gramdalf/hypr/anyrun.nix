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
      ];
      closeOnClick = true;
      showResultsImmediately = true;
      maxEntries = 20;
    };
    #extraCss = ''
    #  .some_class {
    #    background: red;
    #  }
    #'';

    #extraConfigFiles."some-plugin.ron".text = ''
    #  Config(
    #    // for any other plugin
    #    // this file will be put in ~/.config/anyrun/some-plugin.ron
    #    // refer to docs of xdg.configFile for available options
    #  )
    #'';
  };
}
