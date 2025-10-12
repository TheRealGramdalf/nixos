{
  lib,
  stdenv,
  python,
  fetchFromGitHub,
  makeWrapper,
  # deps
  flask,
  flask-sqlalchemy,
  sqlalchemy,
  paramiko,
  python-dotenv,
  gunicorn,
  bcrypt,
}: let
  pname = "timekpr-webui";
  version = "unstable-2025-10-12";

  pyWithLibs = python.buildEnv.override {
    extraLibs = [
      flask
      flask-sqlalchemy
      sqlalchemy
      paramiko
      python-dotenv
      gunicorn
      bcrypt
    ];
  };
in
  stdenv.mkDerivation {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "adambie";
      repo = pname;
      rev = "f777cdfb2009b39ec72282913969486a2140ba3d";
      hash = "sha256-C46t6329sh0qVN+DY3qlp4kTjqI61SVkhnyamMqUres=";
    };

    nativeBuildInputs = [
      makeWrapper
    ];

    installPhase = ''
      mkdir $out
      cp -R $src/* $out

      mkdir $out/bin
      makeWrapper ${lib.getExe pyWithLibs} $out/bin/timekpr-webui \
        --add-flag $out/app.py
    '';

    meta = {
      homepage = "https://github.com/adambie/timekpr-webui";
      description = "Flask-based webUI for timekpr-next";
      license = lib.licenses.mit;
    };
  }
