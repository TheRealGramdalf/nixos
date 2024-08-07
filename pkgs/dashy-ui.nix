{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  settings ? {},
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dashy-ui";
  # This is like 3.1.1 but the latest working yarn.lock.
  # All other changes are for docs with the exception of 768d746cbfcf365c58ad1194c5ccc74c14f3ed3a, which simply adds no-referrer meta tag
  version = "0b1af9db483f80323e782e7834da2a337393e111";
  src = fetchFromGitHub {
    owner = "lissy93";
    repo = "dashy";
    rev = "${finalAttrs.version}";
    hash = "sha256-lRJ3lI9UUIaw9GWPEy81Dbf4cu6rClA4VjdWejVQN+g=";
  };
  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-KVAZIBM47yp1NWYc2esvTwfoAev4q7Wgi0c73PUZRNw=";
  };
  #postUnpack = ''
  #  sed -i 's/printFileReadError(e);/printFileReadError(e);\n  process.exit(1);/gm' source/services/config-validator.js
  #  cat source/services/config-validator.js
  #'';
  # Use postConfigure to prevent colliding with yarnConfigHook
  # If no settings are passed, use the default config provided by upstream
  postConfigure = lib.optional (settings != {}) ''
    echo "Writing settings override..."
    echo '${builtins.toJSON settings}' #> user-data/conf.yml
    exit 1
    yarn validate-config --offline
  '';

  #if [ -z "$VUE_APP_CONFIG_VALID" ]; then
  #  echo "Configuration is invalid, refusing to build"
  #  printenv
  #  exit 1
  #else
  #  echo "Configuration is valid, continuing..."
  #  exit 0
  #fi
  installPhase = ''
    mkdir $out
    cp -R dist/* $out
  '';

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
  ];
  meta = {
    description = "dashy";
    homepage = "https://dashy.to";
    license = lib.licenses.mit;
    #maintainers = [ lib.maintainers.gramdalf ];
  };
})
