#!/bin/sh

set -e

readonly version="7.42.105112.761"

case "$(uname -s)-$(uname -m)" in
    Linux-x86_64)
        # https://files.pvs-studio.com/pvs-studio-7.42.105112.761-x86_64.tgz
        shatool="sha256sum"
        sha256sum="0ced11d17855cc172a860f8cc19a89f10adb6ab7185992fb57474118e9bdabd7"
        filename="pvs-studio-$version-x86_64"
        ;;
    *)
        echo "Unrecognized platform $(uname -s)-$(uname -m)"
        exit 1
        ;;
esac
readonly shatool
readonly sha256sum

cd .gitlab

# This URL is only visible inside of Kitware's network.  See above filename table.
baseurl="https://cmake.org/files/dependencies/internal"

tarball="$filename.tgz"
echo "$sha256sum  $tarball" > pvs-studio.sha256sum
curl -OL "$baseurl/$tarball"
$shatool --check pvs-studio.sha256sum
tar xzf "$tarball"
rm "$tarball" pvs-studio.sha256sum
mv "$filename" "pvs-studio"
