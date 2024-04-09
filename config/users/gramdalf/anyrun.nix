{ config, pkgs, lib, context, ... }: {
  imports = [
    context.anyrun.homeManagerModules.default
  ];
  programs.anyrun = {
    enable = true;
    package = "${context.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}";
    config = {
      plugins = [
      #  # An array of all the plugins you want, which either can be paths to the .so files, or their packages
      #  context.anyrun.packages.${pkgs.system}.applications
      #  ./some_plugin.so
      #  "${context.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}/lib/kidex"
        "${context.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}"
      ];
      closeOnClick = true;
      showResultsImmediately = false;
      maxEntries = 20;
    };
    #extraCss = ''
    #  .some_class {
    #    background: red;
    #  }
    #'';

    extraConfigFiles."some-plugin.ron".text = ''
      Config(
        // for any other plugin
        // this file will be put in ~/.config/anyrun/some-plugin.ron
        // refer to docs of xdg.configFile for available options
      )
    '';
  };
}