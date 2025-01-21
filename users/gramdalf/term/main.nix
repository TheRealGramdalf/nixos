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
      extraConfig = ''
        IdentityFile = ~/.ssh/gramdalf-key
	User = root
      '';
    };
    bash = {
      ls = "lsd";

    };
  };
}
