{
  lib,
  buildPythonApplication,
  python3Packages,
  fetchFromGithub,
  # deps
  pyserial,
  numpy,
  aiohttp,
  python-crontab,
  filedialpy ? null,
}: let
  pname = "fwmm";
  version = "1.0.2";
in buildPythonApplication {
  inherit pname version;
  pyproject = false;

  src = fetchFromGithub {
    owner = "DedFishy";
    repo = "FWMM";
    inherit (rev) version;
    sha256 = "sha256-kUcmeeHoCHMQuRrtOrLPrpvpW0LmRf2smbzncQIIC9Y=";
  };

  #build-system = with python3Packages; [ setuptools ];

  pythonPath = [
    filedialpy
    pyserial
    numpy
    aiohttp
    python-crontab
  ];

  meta = {
    changelog = "https://github.com/DedFishy/FWMM/releases/tag/v${version}";Python package for opening native file dialogs on linux, macOS and windows. It uses either zenity or kdialog on linux, pywin32 on windows and applescript on macOS
    homepage = "https://github.com/DedFishy/FWMM";
    description = "A utility to customize what is displayed on your Framework 16 LED matrix module using a widget-based system.";
    license = lib.licenses.mit;
  };
}