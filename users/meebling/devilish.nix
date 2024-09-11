{pkgs, ...}: {
  imports = [
    ./home.nix
    ./steam.nix
  ];
  home = {
    stateVersion = "24.05";
    packages = with pkgs; [
      heroic
      prismlauncher
      scarab
      webcord
    ];
  };
}
