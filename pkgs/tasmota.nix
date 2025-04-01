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
  version ? "v14.5.0"
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tasmota";
  inherit version;
  src = fetchFromGitHub {
    owner = "arendst";
    repo = "Tasmota";
    rev = version;
    hash = "sha256-edJ+Zh0Sx/DF3v3zqXizE8x7uuWwINYg/Twch/E3GRQ=";
  };
  preBuild = ''
    echo "Writing settings override..."
    echo ${userConfig} > tasmota/user_config_override.h
  '';
  buildPhase = ''
    platformio run -e ${variant} --disable-auto-clean
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
