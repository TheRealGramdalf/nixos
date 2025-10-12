Since wazuh is both complex and relied uppon for security information, decisions regarding implementation that differs from upstream should be recorded here - include the changes made, the motivation for the change, and source code (pinned to a revision) from upstream if relevant. For information regarding the NixOS Module, see the accompanying document in `nixos/modules/security/wazuh/README.md`

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