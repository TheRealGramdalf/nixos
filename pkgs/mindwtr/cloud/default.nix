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
      #tag = version;
      rev = "eba61c096b6c891813ea4fb1619b05b65c136d86";
      hash = "sha256-kofFjdHFl8I8sTcpVv4EFC28d9ZHB83yiX0Jray5Q3Q=";
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
