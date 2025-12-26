{
  pkgs,
  config,
  ...
}: {
  home = {
    username = "gramdalf";
    homeDirectory = "/home/gramdalf";
    stateVersion = "24.05";
    shellAliases = {
      lla = "ls -la";
      resu = "sudo !!";
      speedtest = "speedtest-cli";
      # Don't overwrite files with `mv`
      mv = "mv -n";
      # Don't overwrite the entire disk with 0s when formatting as NTFS
      "mkfs.ntfs" = "mkfs.ntfs --quick";
      # Needs to be a function, but should work otherwise
      # json2nix = "nix eval --impure --expr 'builtins.fromJSON (builtins.readFile $@)'"
    };

    sessionVariables = {
      EDITOR = "nvim";
      NH_FLAKE = "nix";
    };
    packages = with pkgs; [
      jetbrains.idea-community
      wlr-randr
      ripgrep
      #### GUI ####
      exfatprogs
      handbrake
      meld
      remmina
      android-studio
      # Shell/terminal
      neovim
      nerd-fonts.fantasque-sans-mono
      # Communication
      vesktop
      dorion
      electron-mail
      chatterino2
      # Word Processing
      libreoffice
      onlyoffice-desktopeditors # For improved compatibility over libreoffice
      vscodium
      obsidian
      # Add graphviz for dot. nox = no xorg
      graphviz-nox
      pandoc
      # Services
      bitwarden-desktop
      denaro
      #celeste
      jellyfin-web
      pika-backup
      protonvpn-gui
      #nextcloud-client
      # File editors
      #audacity
      # pitivi # Video editor
      blender
      gimp
      #calibre # https://github.com/NixOS/nixpkgs/issues/305577
      drawio
      # Utilities
      freecad
      btop
      inkscape
      picard # MusicBrainz Tagger
      wireshark
      dive
      filezilla
      motrix # Download manager
      gnome-calculator
      gnome-system-monitor
      gnome-sound-recorder
      gnome-obfuscate
      baobab # Disk usage analyzer
      gnome-disk-utility
      whatip
      gnome-solanum # Pomodoro timer
      #eartag # File tag editor - broken, python sucks
      evince # Document viewer
      clapper # Video viewer
      eog # Photo viewer
      gnome-power-manager # Battery stats
      #textpieces # Manipulate text without random websites
      dialect # Translate app
      iotas # MD notes app
      drawing
      vlc
      gnome-clocks
      gnome-maps
      nautilus
      simple-scan
      #gnome-connections
      gnome-secrets
      gnome-font-viewer
      obs-studio
      tauon
      podman-desktop
      # Partition tools
      testdisk
      gparted
      #rpi-imager
      # Settings
      dconf-editor
      gnome-tweaks
      # Web browsers
      brave
      epiphany
      qbittorrent
      tor-browser
      # Hypervisors
      bottles
      # Games
      prismlauncher
      mangohud # System usage stats
      orca-slicer
      #### CLI ####
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
      pdfmixtool
      #(ventoy.override {
      #  withGtk3 = true;
      #  defaultGuiType = "gtk3";
      #  withNtfs = true;
      #  withExt4 = true;
      #  withCryptsetup = true;
      #  withXfs = true;
      #})
      tio
      itch
      esptool
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
      piper
    ];
  };
  programs = {
    home-manager.enable = true;
    bash.enable = true;

    vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles."default".extensions = with pkgs.vscode-extensions; [
        # VSCodium Extensions
        arrterian.nix-env-selector
        #mkhl.direnv
        piousdeer.adwaita-theme
        jnoortheen.nix-ide
      ];
    };
    git = {
      enable = true;
      settings.user = {
        email = "gramdalftech@gmail.com";
        name = "TheRealGramdalf";
      };
    };
  };

  #dconf.settings = {
  #  "org/gtk/gtk4/settings/file-chooser" = {
  #    sort-directories-first = true;
  #    show-create-link = true;
  #    show-delete-permanently = true;
  #    clock-format = "12h";
  #  };
  #  "org/gnome/nautilus/preferences" = {
  #    show-create-link = true;
  #    sort-directories-first = true;
  #    show-delete-permanently = true;
  #  };
  #};
}
