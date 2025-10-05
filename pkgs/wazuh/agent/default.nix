{
  autoconf,
  automake,
  clang,
  cmake,
  curl,
  elfutils,
  fetchFromGitHub,
  fetchurl,
  lib,
  libbfd,
  libbpf,
  libcap,
  libelf,
  libgcc,
  libtool,
  llvm,
  openssl,
  patchelf,
  perl,
  pkg-config,
  policycoreutils,
  python312,
  removeReferencesTo,
  stdenv,
  systemd,
  zlib,
  ...
}: let
  version = "4.12.0";
  dependencyVersion = "40";
  external-dependencies = (
    import ./dependencies {
      inherit fetchurl lib dependencyVersion;
    }
  );
  wazuh-http-request = fetchFromGitHub {
    owner = "wazuh";
    repo = "wazuh-http-request";
    rev = "75384783d339a817b8d8f13f778051a878d642a6";
    sha256 = "sha256-yCKxwzG65BB3Cr1gEkX4qxbGCjG5zzJpq9di5L1couU=";
  };
  libbpf_bootstrap_deps = {
    bootstrap = fetchFromGitHub {
      owner = "libbpf";
      repo = "libbpf-bootstrap";
      rev = "aa18cc0d8fc8ef4104fb74d218ae6a20cf6eb176";
      sha256 = "sha256-ggIDf/I4QlSypFpsRibsdWd9bSevC2mfyEenlYZQdqI=";
      fetchSubmodules = true;
    };
    modern_bpf_c = fetchurl {
      url = "https://raw.githubusercontent.com/wazuh/wazuh/v${version}/src/syscheckd/src/ebpf/src/modern.bpf.c";
      hash = "sha256-mnPGgEoBZgXT6KxNCHEYt8eZHqrWIJjajxwiifpff+A=";
    };
  };
in
  stdenv.mkDerivation {
    pname = "wazuh-agent";
    inherit version;

    src = fetchFromGitHub {
      owner = "wazuh";
      repo = "wazuh";
      rev = "v${version}";
      sha256 = "sha256-yWth09J1SSEi6xGCA8oAkVcBBEnXyOAWOnTNuXWEnNk=";
    };

    dontConfigure = true;
    dontFixup = true;

    hardeningDisable = [
      "zerocallusedregs"
    ];

    nativeBuildInputs = [
      autoconf
      automake
      clang
      cmake
      curl
      perl
      pkg-config
      policycoreutils
      python312
      zlib
    ];

    buildInputs = [
      elfutils
      libbfd
      libbpf
      libcap
      libelf
      libtool
      llvm
      openssl
    ];

    makeFlags = [
      "-C src"
      "TARGET=agent"
      "INSTALLDIR=$out"
    ];

    patches = [
      ./01-makefile-patch.patch
      ./02-libbpf-bootstrap.patch
    ];

    unpackPhase = ''
      runHook preUnpack

      cp -rf --no-preserve=all "$src"/* .

      mkdir -p src/external
      ${lib.strings.concatMapStringsSep "\n" (
          dep: "tar -xzf ${dep} -C src/external"
        )
        external-dependencies}

      mkdir -p src/external/libbpf-bootstrap/src
      cp --no-preserve=all -rf ${libbpf_bootstrap_deps.bootstrap}/* src/external/libbpf-bootstrap
      cp ${libbpf_bootstrap_deps.modern_bpf_c} src/external/libbpf-bootstrap/src/modern.bpf.c

      cp --no-preserve=all -rf ${wazuh-http-request}/* src/shared_modules/http-request/

      runHook postUnpack
    '';

    prePatch = ''
      substituteInPlace src/init/wazuh-server.sh \
        --replace-fail "cd ''${LOCAL}" ""

      substituteInPlace src/external/audit-userspace/autogen.sh \
        --replace-warn "cp INSTALL.tmp INSTALL" ""

      substituteInPlace src/external/openssl/config \
        --replace-warn "/usr/bin/env" "env"

      substituteInPlace src/init/inst-functions.sh \
        --replace-warn "WAZUH_GROUP='wazuh'" "WAZUH_GROUP='nixbld'" \
        --replace-warn "WAZUH_USER='wazuh'" "WAZUH_USER='nixbld'"

      substituteInPlace src/external/libbpf-bootstrap/CMakeLists.txt \
        --replace-fail "/usr/bin/clang" "${clang}/bin/clang"

      cat << EOF > "etc/preloaded-vars.conf"
      USER_LANGUAGE="en"
      USER_NO_STOP="y"
      USER_INSTALL_TYPE="agent"
      USER_DIR="$out"
      USER_DELETE_DIR="n"
      USER_ENABLE_ACTIVE_RESPONSE="y"
      USER_ENABLE_SYSCHECK="n"
      USER_ENABLE_ROOTCHECK="y"
      USER_AGENT_SERVER_IP=127.0.0.1
      USER_CA_STORE="n"
      EOF
    '';

    preBuild = ''
      make -C src TARGET=agent settings
      make -C src TARGET=agent INSTALLDIR=$out deps
    '';

    installPhase = ''
      mkdir -p $out/{bin,etc/shared,queue,var,wodles,logs,lib,tmp,agentless,active-response}

      substituteInPlace install.sh \
        --replace-warn "Xroot" "Xnixbld"
      chmod u+x install.sh

      INSTALLDIR=$out USER_DIR=$out ./install.sh binary-install

      substituteInPlace $out/bin/wazuh-control \
        --replace-fail "cd ''${LOCAL}" "#"

      chmod u+x $out/bin/* $out/active-response/bin/*

      ${removeReferencesTo}/bin/remove-references-to \
        -t ${libgcc.out} \
        $out/lib/*

      ${patchelf}/bin/patchelf --add-rpath ${systemd}/lib $out/bin/wazuh-logcollector
      rm -rf $out/src
    '';

    meta = {
      description = "Wazuh agent for NixOS";
      homepage = "https://wazuh.com";
    };
  }
