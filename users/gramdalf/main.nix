{config, ...}: {
  imports = [
    ./home.nix
    #./hypr/hypr.nix
    ./firefox.nix
    ./term/main.nix
    ./steam.nix
  ];
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };
}
