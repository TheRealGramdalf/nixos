{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  python,
  # deps
  psutil,
  pyserial,
  numpy,
  aiohttp,
  python-crontab,
  filedialpy ? null,
}: let
  pname = "fwmm";
  version = "1.0.3";

  pyWithLibs = python.buildEnv.override {
    extraLibs = [
      filedialpy
      pyserial
      numpy
      aiohttp
      python-crontab
      psutil
    ];
  };
in
  stdenv.mkDerivation {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "DedFishy";
      repo = "FWMM";
      rev = "v${version}";
      hash = "sha256-rwPLB7VeakR84/VEopd9XXby05bujQOCfNLTDVQyz1Y=";
    };

    nativeBuildInputs = [
      makeWrapper
    ];

    installPhase = ''
      mkdir $out
      cp -R $src/* $out

      mkdir $out/bin
      makeWrapper ${lib.getExe pyWithLibs} $out/bin/fwmm \
        --add-flag $out/main.py \
        --chdir $out
    '';

    meta = {
      changelog = "https://github.com/DedFishy/FWMM/releases/tag/v${version}";
      homepage = "https://github.com/DedFishy/FWMM";
      description = "A utility to customize what is displayed on your Framework 16 LED matrix module using a widget-based system.";
      license = lib.licenses.mit;
    };
  }
