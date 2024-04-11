{ config, lib, pkgs, ... }: {
  programs.firefox = {
    enable = true;
    profiles."gramdalf" = {
       isDefault = true;
       userChrome = builtins.readFile (pkgs.fetchFromGitHub {
        owner = "soulhotel";
        repo = "FF-ULTIMA";
        rev = "1.6.8";
        hash = "sha256-q+AyJF1cocyh2zWmp0VbLmduLbJqcfKQVbWlHUjCm5A=";
      } + "/userChrome.css");
      userContent = builtins.readFile (pkgs.fetchFromGitHub {
        owner = "soulhotel";
        repo = "FF-ULTIMA";
        rev = "1.6.8";
        hash = "sha256-q+AyJF1cocyh2zWmp0VbLmduLbJqcfKQVbWlHUjCm5A=";
      } + "/userContent.css");
    };
  };

# https://stackoverflow.com/questions/53658303/fetchfromgithub-filter-down-and-use-as-environment-etc-file-source

  home.file.".firefox/ff-ultima".source = pkgs.fetchFromGitHub {
    owner = "soulhotel";
    repo = "FF-ULTIMA";
    rev = "1.6.8";
    hash = "sha256-q+AyJF1cocyh2zWmp0VbLmduLbJqcfKQVbWlHUjCm5A=";
  };
}