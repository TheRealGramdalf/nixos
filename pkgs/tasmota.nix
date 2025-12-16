{
  lib,
  stdenv,
  fetchFromGitHub,
  esptool,
  platformio,
  platformio-core,
  python312,
  python312Packages,
  userConfig ? null,
  variant ? "tasmota",
  version ? "v15.1.0",
}: 
stdenv.mkDerivation {
  pname = "tasmota";
  inherit version;
  src = fetchFromGitHub {
    owner = "arendst";
    repo = "Tasmota";
    tag = version;
    hash = "sha256-0wAGaOwVwfvMxKeIIxQjuMnWocwPE9sXWrKOwWJDu+Q=";
  };


  configurePhase = ''
    echo "Writing settings override..."
    echo '${userConfig}' > tasmota/user_config_override.h
  '';
  buildPhase = ''
    pio run -e ${variant} --disable-auto-clean
  '';
  installPhase = ''
    mkdir $out
    cp -r --reflink=auto -- build_output/* $out
  '';

  nativeBuildInputs = [
    esptool
    #espflash
    #uclibc
    #zopfli
    platformio
    platformio-core
    python312
    python312Packages.pip
    python312Packages.zopfli
    python312Packages.wheel
  ];

  meta = {
    description = "Tasmota firmware";
    homepage = "https://tasmota.github.io";
    license = lib.licenses.gpl3;
    maintainers = [lib.maintainers.therealgramdalf];
  };
}
