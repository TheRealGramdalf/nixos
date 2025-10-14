#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash nixfmt

EXTERNAL_DEPS=(
    "audit-userspace"
    "benchmark"
    "bzip2"
    "cJSON"
    "cpp-httplib"
    "cpython_x86_64"
    "curl"
    "flatbuffers"
    "googletest"
    "jemalloc"
    "libarchive"
    "libbpf-bootstrap"
    "libdb"
    "libffi"
    "libpcre2"
    "libplist"
    "libyaml"
    "lua"
    "lzma"
    "msgpack"
    "nlohmann"
    "openssl"
    "pacman"
    "popt"
    "procps"
    "rocksdb"
    "rpm"
    "sqlite"
    "zlib"
)

# Find version at: https://github.com/wazuh/wazuh/blob/v4.13.1/src/Makefile#L1385
#TODO Ensure this stays in sync with dependency version from the package, mismatches can cause prefetched content to be substituted incorrectly 
DEPENDENCY_VERSION=43
BASE_URL="https://packages.wazuh.com/deps/$DEPENDENCY_VERSION/libraries/sources"

echo "{" >external-dependencies.nix

for dep in "${EXTERNAL_DEPS[@]}"; do
    HASH=$(
        nix-prefetch-url "$BASE_URL/$dep.tar.gz" --type sha256 |
            xargs nix hash convert --from nix32 --to sri --hash-algo sha256
    )
    cat <<EOF >>external-dependencies.nix

"$dep" = {
    name = "$dep";
    hash = "$HASH";
};
EOF
done

echo "}" >>external-dependencies.nix

nixfmt external-dependencies.nix