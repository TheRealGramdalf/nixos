{
  fetchFromGitHub,
  bun2nix,
}: let
  version = "v1.1.5";
in
  bun2nix.writeBunApplication {
    pname = "mindwtr-cloud";
    inherit version;
    src = fetchFromGitHub {
      owner = "dongdongbh";
      repo = "mindwtr";
      tag = version;
      hash = "sha256-QVkav1IaLwlg/+IDLdA/rZgFgCQxAHmPpy0k50wZRao=";
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
