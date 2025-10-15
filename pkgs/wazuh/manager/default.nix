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
  inherit (lib) getExe;
  version = "4.13.1";
  dependencyVersion = "43";

  external-dependencies = (
    lib.mapAttrsToList (
      _: dep:
        fetchurl {
          url = "https://packages.wazuh.com/deps/${dependencyVersion}/libraries/sources/${dep.name}.tar.gz";
          hash = dep.hash;
        }
    ) (import ./dependencies/external-dependencies.nix)
  );

  wazuh-http-request = fetchFromGitHub {
    owner = "wazuh";
    repo = "wazuh-http-request";
    rev = "75384783d339a817b8d8f13f778051a878d642a6";
    hash = "sha256-yCKxwzG65BB3Cr1gEkX4qxbGCjG5zzJpq9di5L1couU=";
  };
  libbpf_bootstrap_deps = {
    bootstrap = fetchFromGitHub {
      owner = "libbpf";
      repo = "libbpf-bootstrap";
      rev = "aa18cc0d8fc8ef4104fb74d218ae6a20cf6eb176";
      hash = "sha256-ggIDf/I4QlSypFpsRibsdWd9bSevC2mfyEenlYZQdqI=";
      fetchSubmodules = true;
    };
    modern_bpf_c = fetchurl {
      url = "https://raw.githubusercontent.com/wazuh/wazuh/v${version}/src/syscheckd/src/ebpf/src/modern.bpf.c";
      hash = "sha256-D7NPWwrBblP43U7DoBgZewo4wmn3HWGr14wU85+fOC8=";
    };
  };
  cpython-external-dep = fetchurl {
    url = "https://packages.wazuh.com/deps/${dependencyVersion}/libraries/sources/cpython_x86_64.tar.gz";
    hash = "sha256-swJjIHxnjLnmSd981fl1xWhK2AkZxUpNHj6wG1wyR3Y=";
  };
in
  stdenv.mkDerivation {
    pname = "wazuh-manager";
    inherit version;

    src = fetchFromGitHub {
      owner = "wazuh";
      repo = "wazuh";
      tag = "v${version}";
      hash = "sha256-LmMt2t2ra7kPiYwcy+GIKg5a+LPebTNct/FP5en5JR0=";
    };

    dontConfigure = true;
    #dontFixup = true;

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
      "TARGET=server"
      "INSTALLDIR=$out"
    ];

    patches = [
      ./01-makefile-patch.patch
      ./02-libbpf-bootstrap.patch
      ./03-rocksdb-overflow.patch
    ];

    unpackPhase = ''
      runHook preUnpack

      cp -rf --no-preserve=all "$src"/* .

      mkdir -p src/external

      echo "grabbing cpython:"
      cd src/external
      cp ${cpython-external-dep} ./cpython.tar.gz
      gunzip cpython.tar.gz
      cd ../..

      ${lib.strings.concatMapStringsSep "\n" (
          dep: "tar -xzf ${dep} -C src/external"
        )
        external-dependencies}

      mkdir -p src/external/libbpf-bootstrap/src
      cp --no-preserve=all -rf ${libbpf_bootstrap_deps.bootstrap}/* src/external/libbpf-bootstrap
      cp ${libbpf_bootstrap_deps.modern_bpf_c} src/external/libbpf-bootstrap/src/modern.bpf.c

      cp --no-preserve=all -rf ${wazuh-http-request}/* src/shared_modules/http-request/

      chmod +x src/analysisd/compiled_rules/register_rule.sh

      runHook postUnpack
    '';

    prePatch = ''
      substituteInPlace src/init/wazuh-server.sh \
        --replace-fail "cd ''${LOCAL}" ""

      substituteInPlace src/external/audit-userspace/autogen.sh \
        --replace-fail "cp INSTALL.tmp INSTALL" ""

      #substituteInPlace src/external/openssl/config \
      #  --replace-fail "/usr/bin/env" "env"

      substituteInPlace src/init/inst-functions.sh \
        --replace-fail "WAZUH_GROUP='wazuh'" "WAZUH_GROUP='nixbld'" \
        --replace-fail "WAZUH_USER='wazuh'" "WAZUH_USER='nixbld'"

      substituteInPlace src/external/libbpf-bootstrap/CMakeLists.txt \
        --replace-fail "/usr/bin/clang" "${clang}/bin/clang"

      cat << EOF > "etc/preloaded-vars.conf"
      USER_LANGUAGE="en"
      USER_NO_STOP="y"
      USER_INSTALL_TYPE="server"
      USER_DIR="$out"
      USER_DELETE_DIR="n"
      USER_ENABLE_ACTIVE_RESPONSE="y"
      USER_ENABLE_SYSCHECK="n"
      USER_ENABLE_ROOTCHECK="y"
      USER_CA_STORE="n"
      EOF
    '';

    preBuild = ''
      make -C src TARGET=server settings
      make -C src TARGET=server INSTALLDIR=$out deps
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
    '';

    fixupPhase = ''
      ${getExe removeReferencesTo} \
        -t ${libgcc.out} \
        $out/lib/*

      ${getExe patchelf} --add-rpath ${systemd}/lib $out/bin/wazuh-logcollector
      rm -rf $out/src
    '';

    meta = {
      description = "Wazuh manager for NixOS";
      homepage = "https://wazuh.com";
    };
  }
