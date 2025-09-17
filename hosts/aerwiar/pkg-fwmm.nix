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
  version = "7d1a08294a62c99a8ed23d090c3f92c5f186f580";

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
      rev = version;
      sha256 = "sha256-XgJ4MpUNS7lC2vFP57+mDq+FLZbm9vuw+2dbopAoHwM=";
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
      changelog = "https://github.com/DedFishy/FWMM/releases/tag/v1.0.2";
      homepage = "https://github.com/DedFishy/FWMM";
      description = "A utility to customize what is displayed on your Framework 16 LED matrix module using a widget-based system.";
      license = lib.licenses.mit;
    };
  }
