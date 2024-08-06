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
  configurePhase = lib.optional (settings != {}) ''
    echo ${builtins.toJSON settings} > user-data/conf.yml
  '';
  installPhase = ''
    mkdir $out
    cp -R dist/* $out
  '';

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    # Needed for executing package.json scripts
    nodejs
  ];
  meta = {
    description = "dashy";
    homepage = "https://dashy.to";
    license = lib.licenses.mit;
    #maintainers = [ lib.maintainers.gramdalf ];
  };
})
