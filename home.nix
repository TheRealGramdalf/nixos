{ config, pkgs, lib, ... }:

{  
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  home = {
    username = "mars-monkey";
    homeDirectory = "/home/mars-monkey";
    stateVersion = "24.05";
    
    shellAliases = {
      apt = "nala";
      cl = "clear";
      gp = "git -C ~/nix commit -a -m 'Local changes autocommit' && git -C ~/nix push";
      hcf = "vim ~/nix/home.nix";
      hrb = "home-manager switch --flake ~/nix#mars-monkey && git -C ~/nix commit -a -m 'Local changes autocommit' && git -C ~/nix push";
      hyp = "vim ~/.config/hypr/hyprland.conf";
      up = "nix flake update ~/nix";
      int = "ping -c 5 1.1.1.1";
      l = "ls -ah --color=auto";
      pi = "ssh dietpi@192.168.100.5";
      pib = "ssh dietpi@192.168.100.5 -t ./start.sh";
      rm = "trash";
      scf = "vim ~/nix/configuration.nix";
      srb = "sudo nixos-rebuild switch --flake ~/nix#mars-monkey-laptop && git -C ~/nix commit -a -m 'Local changes autocommit' && git -C ~/nix push";
      srbb = "sudo nixos-rebuild boot --flake ~/nix#mars-monkey-laptop && git -C ~/nix commit -a -m 'Local changes autocommit' && git -C ~/nix push";
      ts = "nix run nixpkgs#";
    };
   
    sessionVariables = {
      EDITOR = "vim";
      MOZ_ENABLE_WAYLAND = "1";
    };
    
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-light";
      size = 24;
    };

    packages = with pkgs; [
      andika
      android-tools
      audacity
      bitwarden
      brave
      brillo
      btop
      calibre
      chromium
      clapper
      cmatrix
      corefonts
      cowsay
      distrobox
      drawing
      du-dust
      eartag
      electron-mail
      eza
      fastfetch
      figlet
      fish
      font-awesome
      geogebra6
      gh
      gimp
      git
      go
      gparted
      hugo
      hw-probe
      intel-gpu-tools
      inter
      iotas
      iperf3
      jitsi
      keepassxc
      kitty
      kodi-wayland
      lf
      librewolf
      libreoffice
      libva-utils
      lolcat
      lunar-client
      mangohud
      mprocs
      neofetch
      nix-index
      nixos-generators
      nushell
      ntfs3g
      obs-studio
      onlyoffice-bin
      pciutils
      plocate
      pfetch-rs
      ponysay
      prismlauncher
      rpi-imager
      sl
      snapshot
      speedtest-cli
      starship
      tealdeer
      xfce.thunar
      trash-cli
      tree
      usbutils
      ventoy-full
      vim
      vlc
      waybar
      webcord
      wget
      whatip
      youtube-dl
      zellij
    ];
  };
  
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    
    bind = [
      "$mod, B, exec, librewolf"
    ]
    ++ (
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10)
      );
  };

  programs = {
    home-manager.enable = true;
    bash.enable = true;    

    kitty = {
      enable = true; 
      theme = "Tokyo Night Moon";

      settings = {
        enable_audio_bell = "no";
        copy_on_select = "clipboard";
        background_opacity = "0.8";
      };

      font = {
        size = 12;
        name = "Noto Sans Mono";
      };
    };

    git = {
      enable = true;
      userName = "mars-monkey";
      userEmail = "91227993+mars-monkey@users.noreply.github.com";
    };

    gh = {
      settings = {
        editor = "vim";
      };
      
      gitCredentialHelper = {
        enable = true;
        hosts = [ "github.com" ];
      };
    };
    
    mangohud = {
      enable = true;
      enableSessionWide = false;
    };
  };
  
  # requires reboot to set gtk stuff lol
  gtk = {
    enable = true;
    
    theme = {
      name = "Adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Noto Sans";
      size = 12;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = "0";
    };
    
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = "0";
    };
  };
  
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = lib.mkForce "adw-gtk3-dark";
    };
  };
}
