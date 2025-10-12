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
      matchBlocks."*" = {
        compression = true;
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
