{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  tkinter,
}: let
  pname = "filedialpy";
  version = "1.3.3";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-u31ms+cVJo17S6L4OKxeSynR8lyf87zmPnietuhWnNc=";
  };

  build-system = [ setuptools ];

  # Does not appear to have tests
  doCheck = false;

  pythonImportsCheck = [
    "filedialpy"
  ];

  dependencies = [
    tkinter
  ];

  meta = {
    # Github only has 1.3.0, pypi has 1.3.3
    changelog = "https://github.com/e-sollier/filedialpy/releases/tag/1.3.0";
    homepage = "https://github.com/e-sollier/filedialpy";
    description = "Python package for opening native file dialogs on linux, macOS and windows. It uses either zenity or kdialog on linux, pywin32 on windows and applescript on macOS";
    license = lib.licenses.gpl3;
  };
}
