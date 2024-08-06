
#  installPhase = ''
#    mkdir $out
#    cp -R dist/* $out
#  '';


{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  settings ?
}: 
stdenv.mkDerivation (finalAttrs: {
  pname = "dashy-ui";
  version = "3.1.1";
  src = fetchFromGitHub {
    owner = "lissy93";
    repo = "dashy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };
  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };
  #postConfigure = ''
  #  echo ${toJSON settings} > $out/user-data/conf.yml
  #'';
  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    # Needed for executing package.json scripts
    nodejs
  ];
  meta = with lib; {
    description = "dashy";
    homepage = "https://dashy.to";
    license = licenses.mit;
    #maintainers = [ maintainers.gramdalf ];
  };
})