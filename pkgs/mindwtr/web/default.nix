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
      tag = version;
      hash = "sha256-QVkav1IaLwlg/+IDLdA/rZgFgCQxAHmPpy0k50wZRao=";
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
