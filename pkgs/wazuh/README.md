Since wazuh is both complex and relied uppon for security information, decisions regarding implementation that differs from upstream should be recorded here - include the changes made, the motivation for the change, and source code (pinned to a revision) from upstream if relevant. For information regarding the NixOS Module, see the accompanying document in `nixos/modules/security/wazuh/README.md`

## Build Targets

Available build targets can be found by running:
```sh
$ nix develop
$ git clone https://github.com/wazuh/wazuh -b $VERSION
$ cd wazuh/src
$ make
```

Current targets (as of v4.13.1) are:
Differences between server, local, and hybrid are unkown
```
TARGET is required:
   make TARGET=server   to build the server
   make TARGET=local      - local version of server
   make TARGET=hybrid     - hybrid version of server
   make TARGET=agent    to build the unix agent
   make TARGET=winagent to build the windows agent
```

## Common Build Errors

If a build fails, check the errors below to see if it matches. These are errors that may crop up in the future due to dependency changes and the like.

##### External-dependencies base URL

The `prefetch-external-dependencies.sh` script fetches dependencies for Wazuh from their servers. At the moment, a base URL of `https://packages.wazuh.com/deps/$DEPENDENCY_VERSION/libraries/sources` is used. There is also `https://packages.wazuh.com/deps/$DEPENDENCY_VERSION/libraries/linux/amd64` available, the full implications of using this instead is currently unkown.

##### External-dependencies failiure
If you see something along the lines of:
```sh
curl -so external/cpython.tar.gz https://packages.wazuh.com/deps/43/libraries/linux/amd64/cpython.tar.gz || true
cd external && [ -f cpython.tar.gz ] && gunzip cpython.tar.gz || true
test -e external/cpython.tar ||\
(curl -so external/cpython.tar.gz https://packages.wazuh.com/deps/43/libraries/sources/cpython_x86_64.tar.gz &&\
cd external && gunzip cpython.tar.gz && tar -xf cpython.tar && rm cpython.tar)
make: *** [Makefile:1499: external/cpython.tar.gz] Error 6
make: Leaving directory '/build/src
```
This is most likely an issue with how Wazuh deals with external dependencies. The basic gist of the logic is this:

> Try to download and extract a prebuilt binary of {dependency} for `hostPlatform` (`libraries/linux/amd64/...`)
> If that fails or doesn’t produce a usable directory, fall back to downloading and extracting the source version instead.
> Always continue even if something fails (never abort).

In the nix sandbox, there is no network access - the `curl` command fails, but it continues anyway due to `|| true`.
This works to our advantage, since one can simply use `fetchurl` to prefetch the dependencies and place them in the directory Wazuh expects.
The network call will fail, but you still end up with the same result due to the file being prefetched and placed where it expects.
The definition for this can be found in `src/Makefile:1500` as of Wazuh 4.13.1

This can be an indicator of two problems - either a missing `external-dependency`, or an incorrect name. With `cpython` in particular, the file as it gets downloaded (from sources) is suffixed with `_x86_64`. The Makefile, however, expects just `cpython.tar.gz`. To fix this, the current best method is to hardcode an extra step for the dependency in `default.nix` that references a `let in` expression with the `fetchurl`.
In the case of a missing dependency, simply adding it's name under `{url}` to `prefetch-external-dependencies.sh` and running it should suffice. Each component (agent, manager) has a different set of required dependencies, ensure you are editing the correct script

## 01-makefile-patch.patch

```diff
-EXTERNAL_LIBS += $(PROCPS_LIB) $(LIBALPM_LIB) $(LIBARCHIVE_LIB)
+EXTERNAL_LIBS += $(PROCPS_LIB) $(LIBALPM_LIB) $(LIBARCHIVE_LIB) $(DB_LIB)
```

This seems to be in place to allow adding database dependencies (mysql, psql) to the list of extra libraries. This may be unneeded/a half-implemented attempt, depending on the default functionality of DB libraries


```diff
-	cd ${EXTERNAL_OPENSSL} && ./config $(OPENSSL_FLAGS) && ${MAKE} build_libs
+	cd ${EXTERNAL_OPENSSL} && perl ./Configure $(OPENSSL_FLAGS) && ${MAKE} build_libs
```

This runs `./Configure` with perl explicitly. It is currently unkown why it is changed to `Configure` from `config`


```diff
 int Privsep_SetUser(uid_t uid)
 {
+    return(OS_SUCCESS);
+
     if (setuid(uid) < 0) {
         return (OS_INVALID);
     }
```

It is currently unkown why this is added; the current theory is due to how Wazuh deals with file ownership at build time. This requires further investigation.

## 02-libbpf-bootstrap.patch

```diff
 ExternalProject_Add(libbpf
   PREFIX libbpf
-  GIT_REPOSITORY https://github.com/libbpf/libbpf.git
-  GIT_TAG v1.5.0  # v1.4.0: f11758a7807893330cc87481a7a16cf956326ab3
   SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/libbpf
   CONFIGURE_COMMAND ""
   BUILD_COMMAND cd ${CMAKE_CURRENT_SOURCE_DIR}/libbpf/src && make CFLAGS="-fPIC${CFLAGS}" LDFLAGS="-lelf${LDFLAGS}"
@@ -26,32 +24,31 @@ ExternalProject_Add(libbpf
     install install_uapi_headers
   BUILD_IN_SOURCE TRUE
   INSTALL_COMMAND ""
+  DOWNLOAD_COMMAND ""
   STEP_TARGETS build
 )
 ```

 This (and the similar entries below) disable the built-in fetching in favor of `fetchFromGitHub`, as they would otherwise error without network access. Only `libbpf/libbpf-bootstrap` is actually `fetchFromGitHub`'d, current theory is that it already contains the other repositories, i.e. as submodules


 ```diff
 -set(FILE_URL "https://raw.githubusercontent.com/wazuh/wazuh/${WAZUH_BRANCH}/src/syscheckd/src/ebpf/src/modern.bpf.c")
+#set(FILE_URL "https://raw.githubusercontent.com/wazuh/wazuh/${WAZUH_BRANCH}/src/syscheckd/src/ebpf/src/modern.bpf.c")
 set(DEST_PATH "${CMAKE_CURRENT_SOURCE_DIR}/src/modern.bpf.c")
-file(DOWNLOAD ${FILE_URL} ${DEST_PATH})
-file(SIZE ${DEST_PATH} FILE_SIZE)
+#file(DOWNLOAD ${FILE_URL} ${DEST_PATH})
+#file(SIZE ${DEST_PATH} FILE_SIZE)
 if(NOT EXISTS ${DEST_PATH} OR FILE_SIZE EQUAL 0)
     message(FATAL_ERROR "Failed to download modern.bpf.c from ${FILE_URL}. Please check WAZUH_BRANCH.")
 endif()
@@ -97,6 +94,7 @@ include_directories(
   ${CMAKE_CURRENT_SOURCE_DIR}/vmlinux.h/include/${ARCH}
 )
```

Again, disable the built-in fetching of `modern.bpf.c`. This is replaced by `fetchurl`. It is unkown whether the if not exists check is required, though it appears to be merely a safeguard against downloading an incorrect file. In that case it should not be necessary as `fetchurl` verifies by checksum already.



```diff
+set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-error=implicit-function-declaration -Wno-error=int-conversion")
 bpf_object(modern src/modern.bpf.c)
 add_dependencies(modern_skel libbpf-build bpftool-build vmlinux.h)
```

The purpose of this is currently unkown


## 03-rocksdb-overflow.patch

```diff
--- a/src/external/rocksdb/util/string_util.cc
+++ b/src/external/rocksdb/util/string_util.cc
@@ -115,7 +115,7 @@ void AppendEscapedStringTo(std::string* str, const Slice& value) {
 }

 std::string NumberToHumanString(int64_t num) {
-  char buf[19];
+  char buf[21];
   int64_t absnum = num < 0 ? -num : num;
   if (absnum < 10000) {
     snprintf(buf, sizeof(buf), "%" PRIi64, num);
```

This patches the `NumberToHumanString` method in rocksdb to increase the buffer size which prevents the compiler from erroring. This mirrors an identical change made upstream in `rocksdb` that is not present in the version used by Wazuh; see https://github.com/facebook/rocksdb/blame/112ff5bb703787186b01d496bc5b32e9477bddbb/util/string_util.cc#L103

This is what Wazuh member Stuti Gupta had to say about it:

> This build failure isn’t specific to Wazuh or RocksDB, but rather to how NixOS handles compilation. NixOS enforces a hardened build environment that treats many compiler warnings as fatal errors. When you build Wazuh from source, it uses vendored RocksDB code that triggers a harmless truncation warning on newer GCC and glibc versions. Under normal Linux builds, this would just be a warning, but NixOS’ defaults—-D_FORTIFY_SOURCE=3, -Werror, and -Wformat-truncation—turn it into a hard failure.
> CMake 4.1.1 isn’t the problem here; it’s the stricter environment. To resolve this you can refer to:
> https://github.com/NixOS/nixpkgs/issues/445447
> You can see the discussion for the same: https://www.reddit.com/r/NixOS/comments/1o48xc2/breaking_hundreds_of_packages_because_of_cmake/Alternatively, you can patch the affected line in string_util.cc to use a larger buffer (e.g., change `char buf[20];` to `char buf[32];`), which prevents the compiler from complaining. https://stackoverflow.com/questions/51534284/how-to-circumvent-format-truncation-warning-in-gccIn short, the issue isn’t caused by Wazuh itself but by NixOS’ strict hardening and warning policies with modern GCC/glibc behavior. Relaxing those checks or applying the small patch allows Wazuh to build successfully.


## Oddities

These are observations made while packaging Wazuh that may or may not have any significance. In no particular order:

- [X] ~~`prefetch-external-dependencies.sh` runs `nix-prefetch-url` twice, and it appears that the file is fetched fully twice - this should be investigated and reduced to a single invocation if possible~~ Fixed, only one invocation is needed since the dependency name is already known, the only thing to gather is the hash. `--print-path` could be added to change from `path is '$outpath'` to just `$outpath`
- [ ] During the unpack phase of the Wazuh source, the `external-dependencies` are fetched. This has the side effect of causing the download progress bar to "stall" when it is nearly complete, seemingly doing nothing as it downloads said dependencies. These should be separated if possible

## Todos

- [X] ~~Figure out what licence to use for Wazuh~~
   - `gpl2only` - Alyssa Ross says:
> gpl2 is deprecated, so at the very least it should be gpl2Only or gpl2Plus. "talk of copyright" isn't an issue generally — it's normal to assert copyright while also offering a license — that's how it works.
   - the LICENCE states `This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License (version 2) as published by the FSF - Free Software Foundation.`, but it also has some other copyright information e.g. `Portions Copyright (C) 2015, Wazuh Inc. Based on work Copyright (C) 2003 - 2013 Trend Micro, Inc.`
- [ ] What `platforms`/`badPlatforms` or `availableOn` types should be used?
   - See https://nixos.org/manual/nixpkgs/stable/#var-meta-platforms
   - Is the meta attribute for where it can be built, or where it can be used? 
- [ ] `install.sh` throws `No action was made to configure Wazuh to start during the boot. Add the following line to your init script: /nix/store/48pihjafyikymv466kx0gvdq2z2clbz3-wazuh-manager-4.13.1/bin/wazuh-control start` - check what exactly causes this (probably `binary-install`?), and see what `wazuh-control` does
- [ ] Wazuh manager throws `substituteStream() in derivation wazuh-manager-4.13.1: ERROR: pattern cd\  doesn't match anything in file '/nix/store/48pihjafyikymv466kx0gvdq2z2clbz3-wazuh-manager-4.13.1/bin/wazuh-control'` - check how `''${LOCAL}` needs to be escaped
- [ ] `install: cannot change ownership of '/nix/store/...-wazuh-manager-4.13.1/...': Invalid argument` is thrown many times, most likely due to `-DUSER` and `-DGLOBALGROUP`
- [ ] Figure out what `cpython` actually does, and how it needs to be patched to work properly:
```sh
mkdir -p /nix/store/48pihjafyikymv466kx0gvdq2z2clbz3-wazuh-manager-4.13.1/framework/python
cp external/cpython.tar.gz /nix/store/48pihjafyikymv466kx0gvdq2z2clbz3-wazuh-manager-4.13.1/framework/python/cpython.tar.gz && tar -xf /nix/store/48pihjafyikymv466kx0gvdq2z2clbz3-wazuh-manager-4.13.1/framework/python/cpython.tar.gz -C /nix/store/48pihjafyikymv466kx0gvdq2z2clbz3-wazuh-manager-4.13.1/framework/python && rm -rf /nix/store/48pihjafyikymv466kx0gvdq2z2clbz3-wazuh-manager-4.13.1/framework/python/cpython.tar.gz
find /nix/store/48pihjafyikymv466kx0gvdq2z2clbz3-wazuh-manager-4.13.1/framework/python -name "*libpython3.10.so.1.0" -exec ln -f {} /nix/store/48pihjafyikymv466kx0gvdq2z2clbz3-wazuh-manager-4.13.1/lib/libpython3.10.so.1.0 \;
cd ../framework && /nix/store/48pihjafyikymv466kx0gvdq2z2clbz3-wazuh-manager-4.13.1/framework/python/bin/python3 -m pip install . --use-pep517 --prefix=/nix/store/48pihjafyikymv466kx0gvdq2z2clbz3-wazuh-manager-4.13.1/framework/python && rm -rf build/
sh: line 1: /nix/store/48pihjafyikymv466kx0gvdq2z2clbz3-wazuh-manager-4.13.1/framework/python/bin/python3: No such file or directory
```
- [ ] `grep: /etc/os-release: No such file or directory` is thrown when running `make`, figure out what this does and whether it needs to be fixed or not
- [ ] `install: invalid user 'wazuh'` is thrown right after `install: cannot change ownership of '/nix/store/48pihjafyikymv466kx0gvdq2z2clbz3-wazuh-manager-4.13.1/etc/local_internal_options.conf': Invalid argument`
- [ ] `install.sh` uses these options currently:
```sh
cat: /etc/resolv.conf: No such file or directory
cat: /etc/resolv.conf: No such file or directory

 Wazuh v4.13.1 (Rev. rc1) Installation Script - https://www.wazuh.com

 You are about to start the installation process of Wazuh.
 You must have a C compiler pre-installed in your system.

  - System: Linux localhost 6.16.11 (Linux 0.0)
  - User: nixbld
  - Host: localhost


  -- Press ENTER to continue or Ctrl-C to abort. --
./install.sh: hash: line 37: ps: not found
./install.sh: hash: line 37: ps: not found
./install.sh: hash: line 37: ps: not found

    - Installation will be made at  /nix/store/48pihjafyikymv466kx0gvdq2z2clbz3-wazuh-manager-4.13.1 .

3- Configuring Wazuh.

  3.1- Do you want e-mail notification? (y/n) [n]:
   --- Email notification disabled.

  3.2- Do you want to run the integrity check daemon? (y/n) [y]:
   - Not running syscheck (integrity check daemon).

  3.3- Do you want to run the rootkit detection engine? (y/n) [y]:
   - Running rootcheck (rootkit detection).

  3.5- Active response allows you to execute a specific
       command based on the events received.
       By default, no active responses are defined.

   - Default white list for the active response:

   - Do you want to add more IPs to the white list? (y/n)? [n]:
  3.6- Do you want to enable remote syslog (port 514 udp)? (y/n) [y]:
   - Remote syslog enabled.

  3.7 - Do you want to run the Auth daemon? (y/n) [y]:
   - Running Auth daemon.

  3.8- Do you want to start Wazuh after the installation? (y/n) [y]:
   - Wazuh will start at the end of installation.

  3.9- Setting the configuration to analyze the following logs:

    -- /nix/store/48pihjafyikymv466kx0gvdq2z2clbz3-wazuh-manager-4.13.1/logs/active-responses.log

 - If you want to monitor any other file, just change
   the ossec.conf and add a new localfile entry.
   Any questions about the configuration can be answered
   by visiting us online at https://documentation.wazuh.com/.


   --- Press ENTER to continue ---
```
- [ ] `make settings` gives this output - useful for investigation
```sh
General settings:
    TARGET:             server
    V:
    DEBUG:
    DEBUGAD
    INSTALLDIR:         ut
    DATABASE:
    ONEWAY:             no
    CLEANFULL:          no
    RESOURCES_URL:      https://packages.wazuh.com/deps/43
    EXTERNAL_SRC_ONLY:
    HTTP_REQUEST_BRANCH:75384783d339a817b8d8f13f778051a878d642a6
User settings:
    WAZUH_GROUP:        wazuh
    WAZUH_USER:         wazuh
USE settings:
    USE_ZEROMQ:         no
    USE_GEOIP:          no
    USE_PRELUDE:        no
    USE_INOTIFY:        no
    USE_BIG_ENDIAN:     no
    USE_SELINUX:        no
    USE_AUDIT:          yes
    DISABLE_SYSC:       no
    DISABLE_CISCAT:     no
    IMAGE_TRUST_CHECKS: 1
    CA_NAME:            DigiCert Assured ID Root CA
Mysql settings:
    includes:
    libs:
Pgsql settings:
    includes:
    libs:
Defines:
    -DOSSECHIDS -DUSER="wazuh" -DGROUPGLOBAL="wazuh" -DLinux -DINOTIFY_ENABLED -D_XOPEN_SOURCE=600 -D_GNU_SOURCE -DIMAGE_TRUST_CHECKS=1 -DCA_NAME='DigiCert Assured ID Root CA' -DENABLE_SYSC -DENABLE_CISCAT -DENABLE_AUDIT
Compiler:
    CFLAGS            -pthread -Iexternal/pacman/lib/libalpm/ -Iexternal/libarchive/libarchive -Wl,--start-group -Iexternal/audit-userspace/lib -g -DNDEBUG -O2 -DOSSECHIDS -DUSER="wazuh" -DGROUPGLOBAL="wazuh" -DLinux -DINOTIFY_ENABLED -D_XOPEN_SOURCE=600 -D_GNU_SOURCE -DIMAGE_TRUST_CHECKS=1 -DCA_NAME='DigiCert Assured ID Root CA' -DENABLE_SYSC -DENABLE_CISCAT -DENABLE_AUDIT -pipe -Wall -Wextra -std=gnu99 -I./ -I./headers/ -Iexternal/openssl/include -Iexternal/cJSON/ -Iexternal/libyaml/include -Iexternal/curl/include -Iexternal/msgpack/include -Iexternal/bzip2/ -Ishared_modules/common -Ishared_modules/dbsync/include -Ishared_modules/rsync/include -Iwazuh_modules/syscollector/include  -Idata_provider/include  -Iexternal/libpcre2/include -Iexternal/rpm//builddir/output/include -Isyscheckd/include -Ishared_modules/router/include -Ishared_modules/content_manager/include -Iwazuh_modules/vulnerability_scanner/include -Iwazuh_modules/inventory_harvester/include -I./shared_modules/
    LDFLAGS           '-Wl,-rpath,/../lib' -pthread -lrt -ldl -O2 -Lshared_modules/dbsync/build/lib -Lshared_modules/rsync/build/lib  -Lwazuh_modules/syscollector/build/lib -Ldata_provider/build/lib -Lsyscheckd/build/lib
    LIBS              -lrt -ldl -lm
    CC                gcc
    MAKE              make
```
- [ ] `/nix/store/7h3qnwgvkw6z2r8lq4j5mks4l6r5x2cq-binutils-2.44/bin/ld: missing --end-group; added as last command line option` is randomly thrown, figure out what that comes from
- [ ] `cd wazuh_modules/syscollector/ && mkdir -p build && cd build && cmake -DTARGET=server -DCMAKE_SYMBOLS_IN_RELEASE=ON    .. && make` throws `CMake Warning: Manually-specified variables were not used by the project: TARGET` - check where that comes from (env var or CLI flag) and remove if possible
- [ ] Nix throws `Warning: supplying the --target bpf != x86_64-unknown-linux-gnu argument to a nix-wrapped compiler may not work correctly - cc-wrapper is currently not designed with multi-target compilers in mind. You may want to use an un-wrapped compiler instead.`. Investigate.
- [ ] cmake throws a deprecation warning, ask the Wazuh team about this (nix uses cmake `4.x`, wazuh docs ask for `3.18`)
```
CMake Deprecation Warning at CMakeLists.txt:2 (cmake_policy):
  Compatibility with CMake < 3.10 will be removed from a future version of
  CMake.

  Update the VERSION argument <min> value.  Or, use the <min>...<max> syntax
  to tell CMake that the project requires at least <min> but has been updated
  to work with policies introduced by <max> or earlier.
```
- [ ] Investigate rocksdb dependencies (`liburing` and `git` were not present)
```
cd external/rocksdb/ && mkdir -p build && cd build && cmake .. -DCMAKE_BUILD_TYPE=Release -DWITH_GFLAGS=0 -DWITH_TESTS=0 -DWITH_BENCHMARK_TOOLS=0 -DWITH_TOOLS=0 -DUSE_RTTI=1 -DROCKSDB_BUILD_SHARED=1 -DWITH_BZ2=1 -DBZIP2_INCLUDE_DIR=/build/source/src/external/bzip2 -DBZIP2_LIBRARIES=/build/source/src/external/bzip2/libbz2.a -DCMAKE_POSITION_INDEPENDENT_CODE=1 -DWITH_ALL_TESTS=0 -DWITH_RUNTIME_DEBUG=0 -DWITH_TRACE_TOOLS=0 -DPORTABLE=1 && make
-- The CXX compiler identification is GNU 14.3.0
-- The C compiler identification is GNU 14.3.0
-- The ASM compiler identification is GNU
-- Found assembler: /nix/store/dmypp1h4ldn0vfk3fi6yfyf5yxp9yz0k-gcc-wrapper-14.3.0/bin/gcc
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Check for working CXX compiler: /nix/store/dmypp1h4ldn0vfk3fi6yfyf5yxp9yz0k-gcc-wrapper-14.3.0/bin/g++ - skipped
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Check for working C compiler: /nix/store/dmypp1h4ldn0vfk3fi6yfyf5yxp9yz0k-gcc-wrapper-14.3.0/bin/gcc - skipped
-- Detecting C compile features
-- Detecting C compile features - done
-- Found BZip2: /build/source/src/external/bzip2/libbz2.a (found version "1.0.8")
-- Looking for BZ2_bzCompressInit
-- Looking for BZ2_bzCompressInit - found
-- Performing Test HAVE_OMIT_LEAF_FRAME_POINTER
-- Performing Test HAVE_OMIT_LEAF_FRAME_POINTER - Success
-- Performing Test BUILTIN_ATOMIC
-- Performing Test BUILTIN_ATOMIC - Success
-- Could NOT find uring (missing: uring_LIBRARIES uring_INCLUDE_DIR)
-- Enabling RTTI in all builds
-- Performing Test HAVE_FALLOCATE
-- Performing Test HAVE_FALLOCATE - Success
-- Performing Test HAVE_SYNC_FILE_RANGE_WRITE
-- Performing Test HAVE_SYNC_FILE_RANGE_WRITE - Success
-- Performing Test HAVE_PTHREAD_MUTEX_ADAPTIVE_NP
-- Performing Test HAVE_PTHREAD_MUTEX_ADAPTIVE_NP - Success
-- Looking for malloc_usable_size
-- Looking for malloc_usable_size - found
-- Looking for sched_getcpu
-- Looking for sched_getcpu - found
-- Looking for getauxval
-- Looking for getauxval - not found
-- Looking for F_FULLFSYNC
-- Looking for F_FULLFSYNC - not found
-- Performing Test CMAKE_HAVE_LIBC_PTHREAD
-- Performing Test CMAKE_HAVE_LIBC_PTHREAD - Success
-- Found Threads: TRUE
-- ROCKSDB_PLUGINS:
-- ROCKSDB PLUGINS TO BUILD
-- Could NOT find Git (missing: GIT_EXECUTABLE)
-- JNI library is disabled
-- Configuring done (8.1s)
-- Generating done (0.2s)
-- Build files have been written to: /build/source/src/external/rocksdb/build
```
- [ ] `jemalloc` build throws:
```
./configure: line 8372: cd: null directory
Missing VERSION file, and unable to generate it; creating bogus VERSION
```