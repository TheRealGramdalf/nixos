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
  version = "v1.1.0";
  cargoRoot = "apps/desktop/src-tauri";
in
  rustPlatform.buildRustPackage {
    pname = "mindwtr-desktop";
    inherit version;
    src = fetchFromGitHub {
      owner = "dongdongbh";
      repo = "mindwtr";
      tag = version;
      hash = "sha256-nIMMzvjW0+jcw9/VtASxniAJPDF59Cl03XPUEEqWFf8=";
    };
    cargoHash = "sha256-o1VqnlJcSRw8Zp+v45eEx/UlLtxt1treoqUVCwFqVe4=";

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
