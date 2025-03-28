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
  variant ? "tasmota"
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tasmota";
  version = "v14.5.0";
  src = fetchFromGitHub {
    owner = "arendst";
    repo = "Tasmota";
    rev = "d436a4034b381b7587950f1c85d365212d5a24f2";
    hash = "sha256-edJ+Zh0Sx/DF3v3zqXizE8x7uuWwINYg/Twch/E3GRQ=";
  };
  preBuild = lib.optional (userConfig != null) ''
    echo ${userConfig} > tasmota/user_config_override.h
  '';
  buildPhase = ''
    pwd
    ls -la
    platformio run -e ${variant}
  '';
  installPhase = ''
    mkdir $out
    cp -R build_output/* $out
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
})
