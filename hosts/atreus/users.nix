{inputs, ...}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    sharedModules = [
      ../../mods/home/main.nix
    ];
    users."meebling" = import ../../users/meebling/main.nix;
    users."meeblingthedevilish" = import ../../users/meebling/devilish.nix;
    users."zoom" = import ../../users/meebling/zoom.nix;
    users."music" = import ../../users/meebling/music.nix;
  };
  users.mutableUsers = false;
  users.users."meebling" = {
    isNormalUser = true;
    hashedPasswordFile = "/persist/secrets/passwdfile.meebling";
    extraGroups = ["video" "networkmanager"];
  };
  users.users."meeblingthedevilish" = {
    isNormalUser = true;
    hashedPasswordFile = "/persist/secrets/passwdfile.meeblingthedevilish";
    extraGroups = ["video" "networkmanager"];
  };
  users.users."zoom" = {
    isNormalUser = true;
    hashedPasswordFile = "/persist/secrets/passwdfile.meebling";
    extraGroups = ["video" "networkmanager"];
  };
  users.users."music" = {
    isNormalUser = true;
    hashedPasswordFile = "/persist/secrets/passwdfile.meebling";
    extraGroups = ["video" "networkmanager"];
  };
}
