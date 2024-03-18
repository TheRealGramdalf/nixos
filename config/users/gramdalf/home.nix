{ config, pkgs, lib, ... }:

{
  imports = [
    ./zsh.nix
    ./ddterm.nix
  ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];
  home = {
    username = "gramdalf";
    homeDirectory = "/home/gramdalf";
    stateVersion = "24.05";
    # Custom txt files (Source: https://github.com/nix-community/home-manager/issues/1493)
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
      word2md = "pandoc -f docx -t commonmark $1 -o $2";
    };
    
    sessionVariables = {
      EDITOR = "nvim";
      MOZ_ENABLE_WAYLAND = "1";
      QT_STYLE_OVERRIDE = "adwaita";
      QT_QPA_PLATFORMTHEME = "gnome";
    };
    packages = with pkgs; [
      #### GUI ####
      exfatprogs
      handbrake
      appflowy
      meld
      remmina
      # Shell/terminal
      neovim
      nerdfonts
      gnome.gnome-terminal
      # Communication
      webcord
      electron-mail
      jitsi
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
      kodi-wayland
      jellyfin-web
      pika-backup
      protonvpn-gui
      nextcloud-client
      newsflash # RSS feed reader
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
      prusa-slicer
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
      gcolor3 # Color picker
      clapper # Video viewer
      gnome.eog # Photo viewer
      gnome.gnome-power-manager # Battery stats
      #textpieces # Manipulate text without random websites
      dialect # Translate app
      iotas # MD notes app
      drawing
      vlc
      gnome.gnome-clocks
      gnome.gnome-logs
      gnome.gnome-maps
      gnome.gnome-characters # Emojis and other chars
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
      gnome-extension-manager
      # Web browsers
      librewolf
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
      #### Theming ####
      adwaita-qt6
      adwaita-qt
      qgnomeplatform
      qgnomeplatform-qt6
      gradience
      adw-gtk3
      #### CLI ####
      kanidm # Kanidm client
      exiftool
      nix-output-monitor
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
      # ntfs3g - Not needed since 5.15?
      # Asus ROG drivers
      asusctl
      # DGPU utils
      supergfxctl
      # Gnome Extensions
      gnomeExtensions.supergfxctl-gex
      gnomeExtensions.vitals
      gnomeExtensions.removable-drive-menu
      gnomeExtensions.espresso
      gnomeExtensions.forge
      gnomeExtensions.blur-my-shell
      gnomeExtensions.just-perfection
      # gnomeExtensions.noannoyance-fork  # To add
      # gnomeExtensions.zen  # To add?
    ];
  };  
  programs = {
    home-manager.enable = true;
    bash.enable = true;
    
/*    firefox = {
      enable = true;
      package = pkgs.floorp;
      profiles.gramdalf = {
         isDefault = true;
      }
    };
*/
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
    mangohud = {
      enable = true;
      enableSessionWide = true;
    };
  };
  
  # Requires a full reboot for dark mode to take effect
  gtk = {
    enable = true;
    
    theme = {
      name = "Adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = "0";
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = "0";
    };
  };
  
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      cursor-theme = "SpaceKCursors";
      color-scheme = "prefer-dark";
      gtk-theme = lib.mkForce "adw-gtk3-dark";
      enable-hot-corners = false;
      gtk-enable-primary-paste = false;
      clock-format = "12h";
    };
    "org/gnome/mutter" = {
      dynamic-workspaces = true;
    };
    "org/gnome/desktop/wm/keybindings" = {
      switch-applications = ["disabled"];
      switch-applications-backward = ["disabled"];
      switch-windows = ["<Alt>Tab"];
      switch-windows-backward = ["<Shift><Alt>Tab"];
    };
    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///home/gramdalf/.local/share/backgrounds/2023-09-28-14-40-30-Dragon%20Prince.jpg";
      picture-uri-dark = "file:///home/gramdalf/.local/share/backgrounds/2023-09-28-14-40-30-Dragon%20Prince.jpg";
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };
    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///home/gramdalf/.local/share/backgrounds/2023-09-28-14-40-30-Dragon%20Prince.jpg";
      primary-color = "#000000000000";
      secondary-color ="#000000000000";
    };
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
    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
    };
    # Extensions
    "org/gnome/shell" = {
      disable-user-extensions = false;
      disabled-extensions = [
        "disabled"
      ];
      enabled-extensions = [
        "forge@jmmaranan.com"
        "Vitals@CoreCoding.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "ddterm@amezin.github.com"
        "supergfxctl-gex@asus-linux.org"
        "espresso@coadmunkee.github.com"
        "blur-my-shell@aunetx"
        "just-perfection-desktop@just-perfection"
      ];
    };
    "org/gnome/shell/extensions/vitals" = {
        show-battery = true;
        hot-sensors = [
          "_memory_usage_"
          "_processor_usage_"
          "_battery_state_"
          "_battery_rate_"
        ];
      };
    "org/gnome/shell/extensions/espresso" = {
      show-notifications = false;
    }; 
    "org/gnome/shell/extensions/just-perfection" = {
      app-menu = false;
      activities-button = true;
      dash = false;
      workspace-switcher-should-show = true;
      startup-status = 0;
    };
  };
}
