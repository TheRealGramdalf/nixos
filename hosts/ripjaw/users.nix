{inputs, ...}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    sharedModules = [
      ../../mods/home/main.nix
    ];
    users."games" = import ../../users/games/main.nix;
    users."jhon" = import ../../users/jhon/main.nix;
  };
  users.users."games" = {
    isNormalUser = true;
    hashedPasswordFile = "/persist/secrets/passwdfile.games";
    extraGroups = ["video" "network"];
  };
  users.users."jhon" = {
    isNormalUser = true;
    hashedPasswordFile = "/persist/secrets/passwdfile.jhon";
    extraGroups = ["video" "network" "render"];
  };
  users.mutableUsers = false;
}
