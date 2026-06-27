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
      enableDefaultConfig = false;
      settings."*" = {
        compression = true;
        identityFile = "~/.ssh/gramdalf-key";
        user = "root";

        # Default settings from hm:
        ForwardAgent = false;
        AddKeysToAgent = "no";
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };
    };
    bash = {
      shellAliases = {
        ls = "lsd";
      };
    };
  };
}
