{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  python,
  # deps
  pyserial,
  numpy,
  aiohttp,
  python-crontab,
  filedialpy ? null,
}: let
  pname = "fwmm";
  version = "v1.0.2";

  pyWithLibs = python.buildEnv.override {
    extraLibs = [
      filedialpy
      pyserial
      numpy
      aiohttp
      python-crontab
    ];
    };
in stdenv.mkDerivation {
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

    substituteInPlace $out/main.py \
      --replace-fail 'r+' 'r'

    mkdir $out/bin
    makeWrapper ${lib.getExe pyWithLibs} $out/bin/fwmm \
      --add-flag $out/main.py \
      --chdir $out
  '';

  meta = {
    changelog = "https://github.com/DedFishy/FWMM/releases/tag/${version}";
    homepage = "https://github.com/DedFishy/FWMM";
    description = "A utility to customize what is displayed on your Framework 16 LED matrix module using a widget-based system.";
    license = lib.licenses.mit;
  };
}