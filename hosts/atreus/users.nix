{inputs, ...}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    sharedModules = [
      ../../mods/home/main.nix
    ];
    users."meebling" = import ../../users/meebling/main.nix;
    users."mlem" = import ../../users/meebling/main.nix;
    users."meeblingthedevilish" = import ../../users/meebling/devilish.nix;
  };
  users.mutableUsers = false;
  users.users."meebling" = {
    isNormalUser = true;
    hashedPasswordFile = "/persist/secrets/passwdfile.meebling";
    extraGroups = ["video" "networkmanager"];
  };
  users.users."mlem" = {
    description = "School Only";
    isNormalUser = true;
    hashedPasswordFile = "/persist/secrets/passwdfile.meebling";
    extraGroups = ["video" "networkmanager"];
  };
  users.users."meeblingthedevilish" = {
    description = "Gaming";
    isNormalUser = true;
    hashedPasswordFile = "/persist/secrets/passwdfile.meeblingthedevilish";
    extraGroups = ["video" "networkmanager"];
  };
}
