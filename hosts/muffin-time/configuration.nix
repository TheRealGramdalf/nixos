{pkgs, ...}: {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
      };
    };
    zfs.devNodes = "/dev/disk/by-partlabel";
    plymouth = {
      enable = true;
      theme = "catppuccin-mocha";
      themePackages = [
        (pkgs.catppuccin-plymouth.override {variant = "mocha";})
      ];
    };
    tmp.cleanOnBoot = true;
  };
  # Enable uBlock Origin manually. Thanks, google
  programs.chromium = {
    enable = true;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
    ];
  };
  environment.systemPackages = with pkgs; [
    # NTFS (windows filesystem) support
    ntfs3g
    # MS Teams
    #teams
    # MS Office alternative
    onlyoffice-desktopeditors
    # Google spyware
    google-chrome
    # MIDI/digital audio workstation
    ardour
    # Video player
    vlc
    # Zoom
    zoom-us
    # Musescore
    musescore
    # Audacity
    audacity
    # zotero
    zotero
    # lightweight spotify
    spotify-qt

   
  ];
  nixpkgs.config.permittedInsecurePackages = [
    "adobe-reader-9.5.5"
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  users.mutableUsers = false;
  users.groups."muffin" = {};
  users.users."muffin" = {
    group = "muffin";
    extraGroups = ["wheel" "video"];
    isNormalUser = true;
    hashedPasswordFile = "/persist/secrets/muffin.psw";
  };
}
