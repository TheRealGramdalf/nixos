{
  fetchFromGitHub,
  bun2nix,
  cargo-tauri,
  webkitgtk_4_1,
  rustPlatform,
  pkg-config,
  perl,
  alsa-lib,
  cmake,
  libayatana-appindicator,
  gtk3,
  wrapGAppsHook3,
}: let
  version = "v1.1.5";
  cargoRoot = "apps/desktop/src-tauri";
in
  rustPlatform.buildRustPackage {
    pname = "mindwtr-desktop";
    inherit version;
    src = fetchFromGitHub {
      owner = "dongdongbh";
      repo = "mindwtr";
      #tag = version;
      rev = "eba61c096b6c891813ea4fb1619b05b65c136d86";
      hash = "sha256-kofFjdHFl8I8sTcpVv4EFC28d9ZHB83yiX0Jray5Q3Q=";
    };
    cargoHash = "sha256-eCC0Ilu+swwT7DNuqMb0UdIyMwoaMVT9xVTy76KeXLk=";

    nativeBuildInputs = [
      bun2nix.hook
      cargo-tauri.hook
      rustPlatform.bindgenHook # whisper-rs-sys
      cmake # ^
      perl # openssl
      pkg-config
      wrapGAppsHook3
    ];

    buildInputs = [
      alsa-lib # alsa-sys
      webkitgtk_4_1
      gtk3
      libayatana-appindicator #libappindicator-sys
    ];

    postFixup = ''
      patchelf --add-needed ${libayatana-appindicator}/lib/libayatana-appindicator3.so $out/bin/.mindwtr-wrapped
    '';
    bunDeps = bun2nix.fetchBunDeps {
      bunNix = ../bun.nix;
    };
    dontUseBunBuild = true;
    dontUseBunCheck = true;
    dontUseBunInstall = true;

    inherit cargoRoot;
    buildAndTestSubdir = cargoRoot;
  }
