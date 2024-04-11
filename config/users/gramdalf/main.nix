{ config, lib, pkgs, ... }: {
  imports = [
    ./home.nix
    ./zsh.nix
    ./hypr/hypr.nix
    ./firefox.nix
  ];
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };
}