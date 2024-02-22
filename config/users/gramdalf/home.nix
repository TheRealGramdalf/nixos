{ config, pkgs, lib, ... }:

{
  home = {
    username = "gramdalf";
    homeDirectory = "/home/gramdalf";
    stateVersion = "24.05";
    # Custom txt files (Source: https://github.com/nix-community/home-manager/issues/1493)
    file = {
    # Kanidm client config
    ".config/kanidm".text = ''
      uri = "https://auth.aer.dedyn.io"
      verify_ca = true
      verify_hostnames = true
    '';
    ".icons/SpaceKCursors".source = ./assets/SpaceKCursors;
    # zsh prompt. See `~/.zprompt`
    ".zprompt".source = ./legacyDotfiles/.zprompt;
    # zsh colors. See `~/.zcolors`
    ".zcolors".source = ./legacyDotfiles/.zcolors;
    };
    shellAliases = {
      lla = "ls -la";
      resu = "sudo !!";
      scf = "sudo nano ~/nix/system/configuration.nix &&
            var=$(pwd) &&
            cd ~/nix &&
            git add -A &&
            git commit -m 'Push local changes' &&
            cd $var";
      srb = "sudo nixos-rebuild switch --flake ~/nix/system#aerwiar";
      srbb = "sudo nixos-rebuild boot --flake ~/nix/system#aerwiar";
      hcf = "nano ~/nix/home/home.nix && pushd ~/nix && git add -A && git commit -m 'Push local changes' && popd ";
      hrb = "home-manager switch --flake ~/nix/home#gramdalf";
      gp = "var=$(pwd) && cd ~/nix && git add -A && git commit -m 'Push local repo' && git push && cd $var";
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
      btrfs-progs
      btrfs-assistant
      exfatprogs
      handbrake
      appflowy
      meld
      remmina
      # Shell/terminal
      neovim
      nerdfonts
      zsh
      zsh-autosuggestions
      zsh-syntax-highlighting
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
      # Fonts
      andika
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
      gnomeExtensions.ddterm
      gjs
      gnomeExtensions.blur-my-shell
      gnomeExtensions.just-perfection
      # gnomeExtensions.noannoyance-fork  # To add
      # gnomeExtensions.zen  # To add?
    ];
  };  
  programs = {
    home-manager.enable = true;
    bash.enable = true;
    zsh.enable = true;
    
/*    firefox = {
      enable = true;
      package = pkgs.floorp;
      profiles.gramdalf = {
         isDefault = true;
      }
    };
*/

    zsh = {
      autocd = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      enableVteIntegration = true;
      history = {
        expireDuplicatesFirst = true;
        ignoreDups = true;
        ignoreSpace = true;
        #path = "~/.zsh_history";
        size = 1000;
        save = 2000;
        #share = true;
      };
      completionInit = ''
        # enable completion features
        autoload -Uz compinit
        compinit -d ~/.cache/zcompdump
        zstyle ':completion:*:*:*:*:*' menu select
        zstyle ':completion:*' auto-description 'specify: %d'
        zstyle ':completion:*' completer _expand _complete
        zstyle ':completion:*' format 'Completing %d'
        zstyle ':completion:*' group-name ""
        zstyle ':completion:*' list-colors ""
        zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
        zstyle ':completion:*' rehash true
        zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
        zstyle ':completion:*' use-compctl false
        zstyle ':completion:*' verbose true
        zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
      '';
      # Extra ~/.zshrc style options
      initExtra = ''
        setopt interactivecomments # allow comments in interactive mode
        setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
        setopt nonomatch           # hide error message if there is no match for the pattern
        setopt notify              # report the status of background jobs immediately
        setopt numericglobsort     # sort filenames numerically when it makes sense
        setopt promptsubst         # enable command substitution in prompt
        bindkey ' ' magic-space                           # do history expansion on space
        bindkey '^U' backward-kill-line                   # ctrl + U
        bindkey '^[[3;5~' kill-word                       # ctrl + Supr
        bindkey '^[[3~' delete-char                       # delete
        bindkey '^[[1;5C' forward-word                    # ctrl + ->
        bindkey '^[[1;5D' backward-word                   # ctrl + <-
        bindkey '^[[5~' beginning-of-buffer-or-history    # page up
        bindkey '^[[6~' end-of-buffer-or-history          # page down
        bindkey '^[[H' beginning-of-line                  # home
        bindkey '^[[F' end-of-line                        # end
        bindkey '^[[Z' undo                               # shift + tab undo last action
        # ~/.zprompt 
        [ -f ~/.zprompt ] && source ~/.zprompt || echo "Error: ~/.zprompt does not exist."
        # ~/.zcolors
        [ -f ~/.zcolors ] && source ~/.zcolors || echo "Error: ~/.zcolors does not exist."
        # enable auto-suggestions based on the history
        if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
            . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
            # change suggestion color
            ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
        fi
        # enable command-not-found if installed
        if [ -f /etc/zsh_command_not_found ]; then
            . /etc/zsh_command_not_found
        fi
        # Configure the shell prompt
        configure_prompt
      '';
      sessionVariables = {
        TIMEFMT = "$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'";
        # Don't consider certain characters part of the word
        #WORDCHARS = ''${WORDCHARS//\/}'';
        # hide EOL sign ('%')
        PROMPT_EOL_MARK = "";
        #USR_FLAKE="~/nix/home#gramdalf";
        #SYS_FLAKE="~/nix/system#aerwiar";
      };
    };
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
    "com/github/amezin/ddterm" = {
      # vi/vim requires escape to function
      hide-window-on-esc = false;
      scrollback-unlimited = true;
      show-scrollbar = false;
      notebook-border = false;
      ddterm-toggle-hotkey = [ "F1" ];
      panel-icon-type = "none";
      # Color profile. To migrate to a gnome-terminal profile, see: 
      #  https://mynixos.com/home-manager/options/programs.gnome-terminal.profile.%3Cname%3E
      # Use (FG/BG) colors specified below, not system defaults
      use-theme-colors = false;
      foreground-color = "rgb(230,230,230)"; # Text color
      background-color = "rgb(31,34,41)"; # Backdrop color
      background-opacity = 0.9;
      palette = [
        "rgb(23,20,33)" "rgb(192,28,40)" "rgb(94,189,171)" "rgb(162,115,76)" "rgb(54,123,240)" "rgb(163,71,186)" "rgb(42,161,179)" "rgb(208,207,204)"
        "rgb(94,92,100)" "rgb(246,97,81)" "rgb(51,218,122)" "rgb(233,173,12)" "rgb(42,123,222)" "rgb(192,97,203)" "rgb(51,199,222)" "rgb(255,255,255)"
      ];
      # Default palette: ['rgb(23,20,33)', 'rgb(192,28,40)', 'rgb(38,162,105)', 'rgb(162,115,76)', 'rgb(18,72,139)', 'rgb(163,71,186)', 'rgb(42,161,179)', 'rgb(208,207,204)', 'rgb(94,92,100)', 'rgb(246,97,81)', 'rgb(51,218,122)', 'rgb(233,173,12)', 'rgb(42,123,222)', 'rgb(192,97,203)', 'rgb(51,199,222)', 'rgb(255,255,255)']
    };
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
        "ddterm@amezin.github.com"
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
