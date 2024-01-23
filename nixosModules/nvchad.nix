{ inputs, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  config = {

    environment = {
      systemPackages = with pkgs; [
        zig
        neovim
        git
        ripgrep
        vimPlugins.nvchad-ui
	      vimPlugins.nvchad
      ];
    };
  };
}
