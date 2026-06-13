#!/bin/sh

set -e

readonly version="4.3.2"

case "$(uname -s)-$(uname -m)" in
    Linux-x86_64)
        shatool="sha256sum"
        sha256sum="791ae3604841ca03cb3889a3ad89165346e4b180ae3448efd4b0caa9ef46d245"
        platform="linux-x86_64"
        ;;
    Linux-aarch64)
        shatool="sha256sum"
        sha256sum="377079ab739f5765176f427609d9a2015b756ea20d5cba908d279c3731a2f481"
        platform="linux-aarch64"
        ;;
    Darwin-*)
        shatool="shasum -a 256"
        sha256sum="808ab43a0db04c8eec9ed7db12b90d7be1c8e2e75f4a060724d604a2043ccaf7"
        platform="macos-universal"
        ;;
    *)
        echo "Unrecognized platform $(uname -s)-$(uname -m)"
        exit 1
        ;;
esac
readonly shatool
readonly sha256sum
readonly platform

readonly filename="cmake-$version-$platform"
readonly tarball="$filename.tar.gz"

cd .gitlab

echo "$sha256sum  $tarball" > cmake.sha256sum
curl -OL "https://github.com/Kitware/CMake/releases/download/v$version/$tarball"
$shatool --check cmake.sha256sum
tar xf "$tarball"
mv "$filename" cmake
rm "$tarball" cmake.sha256sum

if [ "$( uname -s )" = "Darwin" ]; then
    ln -s CMake.app/Contents/bin cmake/bin
fi
