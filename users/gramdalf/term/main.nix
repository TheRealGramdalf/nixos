{
  imports = [
    ./term.nix
    ./nushell.nix
  ];
  programs = {
    starship = {
      enable = true;
    };
    ssh = {
      enable = true;
      compression = true;
      matchBlocks."*" = {
        identityFile = "~/.ssh/gramdalf-key";
        user = "root";
      };
    };
    bash = {
      shellAliases = {
        ls = "lsd";
      };
    };
  };
}
