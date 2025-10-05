#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash nixfmt

EXTERNAL_DEPS=(
    "audit-userspace"
    "benchmark"
    "bzip2"
    "cJSON"
    "cpp-httplib"
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

# Find version at: https://github.com/wazuh/wazuh/blob/v4.12.0/src/Makefile#L1385
DEPENDENCY_VERSION=40
BASE_URL="https://packages.wazuh.com/deps/$DEPENDENCY_VERSION/libraries/sources"

echo "{" >external-dependencies.nix

for dep in "${EXTERNAL_DEPS[@]}"; do
    nix-prefetch-url "$BASE_URL/$dep.tar.gz" --type sha256 --print-path
    HASH=$(
        nix-prefetch-url "$BASE_URL/$dep.tar.gz" --type sha256 |
            xargs nix hash convert --from nix32 --to sri --hash-algo sha256
    )
    cat <<EOF >>external-dependencies.nix

"$dep" = {
    name = "$dep";
    sha256 = "$HASH";
};
EOF
done

echo "}" >>external-dependencies.nix

nixfmt external-dependencies.nix