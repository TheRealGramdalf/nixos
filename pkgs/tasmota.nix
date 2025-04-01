{
  pkgs,
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
}: let
  repository = fetchFromGitHub {
    owner = "arendst";
    repo = "Tasmota";
    rev = "v14.5.0";
    hash = "sha256-edJ+Zh0Sx/DF3v3zqXizE8x7uuWwINYg/Twch/E3GRQ=";
  };
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
in
stdenv.mkDerivation (finalAttrs: {
  pname = "tasmota";
  inherit version;
  src = pkgs.runCommand "${version}-pkg-install" {
    inherit nativeBuildInputs;
    outputHashAlgo = null;
    outputHashMode = "recursive";
    outputHash = "sha256-edJ+Zh0Sx/DF3v3zqXizE8x7uuWwINYg/Twch/E3GRQ=";
  } ''
    mkdir $out
    cd $out
    cp -r ${repository}/. .
    platformio pkg install -e ${variant}
  '';
  preBuild = ''
    echo "Writing settings override..."
    echo ${userConfig} > tasmota/user_config_override.h
  '';
  buildPhase = ''
    pio pkg list -e ${variant}
    platformio run -e ${variant} --disable-auto-clean
  '';
  installPhase = ''
    mkdir $out
    cp -R build_output/* $out
  '';

  inherit nativeBuildInputs;
  meta = {
    description = "Tasmota firmware";
    homepage = "https://tasmota.github.io";
    license = lib.licenses.gpl3;
    maintainers = [lib.maintainers.therealgramdalf];
  };
})
