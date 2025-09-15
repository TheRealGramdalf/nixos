{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "filedialpy";
  version = "1.3.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CP3V73yWSArRHBLUct4hrNMjWZlvaaUlkpm1QP66RWA=";
  };

  build-system = [ setuptools ];

  ## has no tests
  #doCheck = false;

  #pythonImportsCheck = [
  #  "toolz.itertoolz"
  #  "toolz.functoolz"
  #  "toolz.dicttoolz"
  #];

  meta = {
    # Github only has 1.3.0, pypi has 1.3.3
    changelog = "https://github.com/e-sollier/filedialpy/releases/tag/1.3.0";
    homepage = "https://github.com/e-sollier/filedialpy";
    description = "Python package for opening native file dialogs on linux, macOS and windows. It uses either zenity or kdialog on linux, pywin32 on windows and applescript on macOS";
    license = lib.licenses.gpl3;
  };
}
