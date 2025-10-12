{inputs, ...}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    sharedModules = [
      ./mods/home/main.nix
    ];
    users."gramdalf" = import ../../users/gramdalf/main.nix;
  };
  users.mutableUsers = false;
  users.users."gramdalf" = {
    isNormalUser = true;
    extraGroups = ["wheel" "video" "netdev" "docker" "adbusers" "plugdev" "wireshark" "dialout"];
    hashedPasswordFile = "/persist/secrets/passwdfile.gramdalf";
    group = "gramdalf";
  };
  users.groups."gramdalf" = {};
}
