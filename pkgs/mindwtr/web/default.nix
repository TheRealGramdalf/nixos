{
  fetchFromGitHub,
  bun2nix,
  stdenv,
}: let
  version = "v1.1.5";
in
  stdenv.mkDerivation {
    pname = "mindwtr-web";
    inherit version;
    src = fetchFromGitHub {
      owner = "dongdongbh";
      repo = "mindwtr";
      rev = "eba61c096b6c891813ea4fb1619b05b65c136d86";
      #tag = version;
      hash = "sha256-kofFjdHFl8I8sTcpVv4EFC28d9ZHB83yiX0Jray5Q3Q=";
    };

    nativeBuildInputs = [
      bun2nix.hook
    ];

    bunDeps = bun2nix.fetchBunDeps {
      bunNix = ../bun.nix;
    };
    bunInstallFlags = [
      "--linker=hoisted"
    ];

    buildPhase = ''
      bun run desktop:web:build
    '';

    installPhase = ''
      mkdir -p $out/dist

      cp -R --reflink=auto ./apps/desktop/dist $out
    '';
  }
