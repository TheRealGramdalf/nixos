{ config, lib, pkgs, fetchFromGithub, ... }: {
  programs.firefox = {
    enable = true;
    profiles."gramdalf" = {
       isDefault = true;
    }
  };


  home.file.".firefox/ff-ultima".source = fetchFromGithub {
    owner = "soulhotel";
    repo = FF-ULTIMA;
    rev = "1.6.8";
    hash = "invalid-nonsense-hash";
  }
}