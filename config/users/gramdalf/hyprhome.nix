{ config, pkgs, lib, ... }:

{
  imports = [
    ./zsh.nix
    ./anyrun.nix
    ./waybar-interim.nix
    ./hypr.nix
    ./gtk.nix
    ./firefox.nix
  ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];
  home = {
    username = "hyprgramdalf";
    homeDirectory = "/home/hyprgramdalf";
    stateVersion = "24.05";
    # Custom txt fI'm getting my Hyprland setup going, and I'm curious if people have an Anyrun iles (Source: https://github.com/nix-community/home-manager/issues/1493)
    file = {
    ".icons/SpaceKCursors".source = ./assets/SpaceKCursors;
    };
    shellAliases = {
      lla = "ls -la";
      resu = "sudo !!";
      speedtest = "speedtest-cli";
      provides = "nix-locate -w";
      # Don't overwrite files with `mv`
      mv = "mv -n";
      # Don't overwrite the entire disk with 0s when formatting as NTFS
      "mkfs.ntfs" = "mkfs.ntfs --quick";
    };
    
    sessionVariables = {
      EDITOR = "nvim";
      MOZ_ENABLE_WAYLAND = "1";
    };
    packages = with pkgs; [
      #### GUI ####
      exfatprogs
      handbrake
      meld
      remmina
      # Shell/terminal
      neovim
      nerdfonts
      # Communication
      webcord
      electron-mail
      zoom-us
      chatterino2
      # Word Processing
      libreoffice
      onlyoffice-bin # For improved compatibility over libreoffice
      vscodium
      obsidian
      pandoc
      # Services
      bitwarden
      denaro
      celeste
      jellyfin-web
      pika-backup
      protonvpn-gui
      nextcloud-client
      # File editors
      audacity
      # pitivi # Video editor
      blender
      gimp
      calibre
      drawio
      # Utilities
      btop
      inkscape
      picard # MusicBrainz Tagger
      wireshark
      dive
      filezilla
      motrix # Download manager
      gnome.gnome-calculator
      gnome.gnome-system-monitor
      gnome.gnome-sound-recorder
      gnome-obfuscate
      baobab # Disk usage analyzer
      gnome.gnome-disk-utility
      whatip
      gnome-solanum # Pomodoro timer
      eartag # File tag editor
      evince # Document viewer
      clapper # Video viewer
      gnome.eog # Photo viewer
      gnome.gnome-power-manager # Battery stats
      #textpieces # Manipulate text without random websites
      dialect # Translate app
      iotas # MD notes app
      drawing
      vlc
      gnome.gnome-clocks
      gnome.gnome-maps
      gnome.nautilus
      gnome.simple-scan
      #gnome-connections
      gnome-secrets
      gnome.gnome-font-viewer
      obs-studio
      tauon
      podman-desktop
      # Partition tools
      testdisk
      gparted
      rpi-imager
      # Settings
      gnome.dconf-editor
      gnome.gnome-tweaks
      # Web browsers
      brave
      epiphany
      qbittorrent
      tor-browser
      # Hypervisors
      bottles
      # Games
      prismlauncher
      steam
      mangohud # System usage stats
      #### CLI ####
      kanidm # Kanidm client
      exiftool
      cmatrix
      android-tools
      speedtest-cli
      unzip
      nix-index
      gh
      git
      gitg
      youtube-tui
      btrbk
      plocate
      neofetch
      tealdeer
      ventoy-full
      firehol
      iperf3
      dmidecode
      usbutils
      pciutils
      smartmontools
      ffmpeg_6-full
      traceroute
      nmap
      arp-scan
      tree
      dig
      cadaver
      #### Libraries/Drivers ####
      # Misc
      libva-utils
    ];
  };  
  programs = {
    home-manager.enable = true;
    bash.enable = true;

    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        # VSCodium Extensions
        arrterian.nix-env-selector
        #mkhl.direnv
        piousdeer.adwaita-theme
        jnoortheen.nix-ide
      ];
    };
    git = {
      enable = true;
      userEmail = "gramdalftech@gmail.com";
      userName = "TheRealGramdalf";
    };
  };
  
  dconf.settings = {
    "org/gtk/gtk4/settings/file-chooser" = {
      sort-directories-first = true;
      show-create-link = true;
      show-delete-permanently = true;
      clock-format = "12h";
    };
    "org/gnome/nautilus/preferences" = {
      show-create-link = true;
      sort-directories-first = true;
      show-delete-permanently = true;
    };
  };
}
