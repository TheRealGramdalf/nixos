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


## Oddities

These are observations made while packaging Wazuh that may or may not have any significance. In no particular order:

- [X] ~~`prefetch-external-dependencies.sh` runs `nix-prefetch-url` twice, and it appears that the file is fetched fully twice - this should be investigated and reduced to a single invocation if possible~~ Fixed, only one invocation is needed since the dependency name is already known, the only thing to gather is the hash. `--print-path` could be added to change from `path is '$outpath'` to just `$outpath`
- [ ] During the unpack phase of the Wazuh source, the `external-dependencies` are fetched. This has the side effect of causing the download progress bar to "stall" when it is nearly complete, seemingly doing nothing as it downloads said dependencies. These should be separated if possible

## Todos

- [ ] Figure out what licence to use for Wazuh
   - the LICENCE states `This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License (version 2) as published by the FSF - Free Software Foundation.`, but it also has some other copyright information e.g. `Portions Copyright (C) 2015, Wazuh Inc. Based on work Copyright (C) 2003 - 2013 Trend Micro, Inc.`
- [ ] What `platforms`/`badPlatforms` or `availableOn` types should be used?
   - See https://nixos.org/manual/nixpkgs/stable/#var-meta-platforms
   - Is the meta attribute for where it can be built, or where it can be used? 