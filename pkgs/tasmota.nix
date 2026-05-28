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
  version ? "v15.4.0",
}:
stdenv.mkDerivation {
  pname = "tasmota";
  inherit version;
  src = fetchFromGitHub {
    owner = "arendst";
    repo = "Tasmota";
    tag = version;
    hash = "sha256-uNby3U9UxQUp4L4FLP6+YnFYbajLoM3Z4wZHCDJViWU=";
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
