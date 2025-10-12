{
  lib,
  buildPythonApplication,
  makeWrapper,
  setuptools,
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
in
  buildPythonApplication {
    inherit pname version;
    pyproject = true;

    src = fetchFromGitHub {
      owner = "adambie";
      repo = pname;
      rev = "f777cdfb2009b39ec72282913969486a2140ba3d";
      hash = "sha256-u31ms+cVJo17S6L4OKxeSynR8lyf87zmPnietuhWnNc=";
    };

    build-system = [setuptools];

    dependencies = [
      flask
      flask-sqlalchemy
      sqlalchemy
      paramiko
      python-dotenv
      gunicorn
      bcrypt
    ];

    #installPhase = ''
    #  mkdir $out
    #  cp -R $src/* $out
    #
    #  mkdir $out/bin
    #  makeWrapper ${lib.getExe pyWithLibs} $out/bin/fwmm \
    #    --add-flag $out/main.py \
    #    --chdir $out
    #'';

    meta = {
      homepage = "https://github.com/adambie/timekpr-webui";
      description = "Flask-based webUI for timekpr-next";
      license = lib.licenses.mit;
    };
  }
