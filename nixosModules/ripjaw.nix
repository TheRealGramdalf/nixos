{ inputs, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  imports = with inputs.self; [
    nixosModules.posix-client
  ];
  config = {
    environment = {
      systemPackages = with pkgs; [
        neovim 
        git
        kanidm
        lsd
      ];
    };

    services = {
      avahi = {
	      enable = true;
        openFirewall = true;
      };
      openssh = {
        enable = true;
        settings.PasswordAuthentication = false;
        settings.PermitRootLogin = "prohibit-password";
        listenAddresses = [{
          addr = "0.0.0.0";
          port = 22;
      }];};
    };
  };
}
