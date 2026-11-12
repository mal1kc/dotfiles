#!/usr/bin/env bash
# download latest GE-Proton and install it into steam compatibilitytools.d
set -euo pipefail

workdir="$(mktemp -d /tmp/proton-ge-custom.XXXXXX)"
trap 'rm -rf "$workdir"' EXIT
cd "$workdir"

release_json="$(curl -fsS https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest)"
tarball_url="$(printf '%s' "$release_json" | grep browser_download_url | cut -d'"' -f4 | grep '\.tar\.gz$')"
checksum_url="$(printf '%s' "$release_json" | grep browser_download_url | cut -d'"' -f4 | grep '\.sha512sum$')"

# download tarball and checksum
curl -fsSLOJ "$tarball_url"
curl -fsSLOJ "$checksum_url"

# stop here (set -e) if the checksum does not match
sha512sum -c ./*.sha512sum

mkdir -p ~/.steam/root/compatibilitytools.d
tar -xf GE-Proton*.tar.gz -C ~/.steam/root/compatibilitytools.d/
echo "All done :)"
