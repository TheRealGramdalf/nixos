{
  fetchFromGitHub,
  bun2nix,
}: let
  version = "v1.1.0";
in
  bun2nix.writeBunApplication {
    pname = "mindwtr-cloud";
    inherit version;
    src = fetchFromGitHub {
      owner = "dongdongbh";
      repo = "mindwtr";
      tag = version;
      hash = "sha256-nIMMzvjW0+jcw9/VtASxniAJPDF59Cl03XPUEEqWFf8=";
    };

    dontUseBunBuild = true;
    startScript = ''
      bun run --filter mindwtr-cloud dev
    '';

    bunDeps = bun2nix.fetchBunDeps {
      bunNix = ../bun.nix;
    };
    bunInstallFlags = [
      "--linker=hoisted"
    ];
  }
