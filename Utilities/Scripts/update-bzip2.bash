#!/usr/bin/env bash

set -e
set -x
shopt -s dotglob

readonly name="bzip2"
readonly ownership="bzip2 upstream <kwrobot@kitware.com>"
readonly subtree="Utilities/cmbzip2"
readonly repo="https://sourceware.org/git/bzip2.git"
readonly tag="af35561761f36e2ce27484ca6d376326a80ebd1d" # bzip2-1.0.8-19-gaf35561
readonly shortlog=false
readonly exact_tree_match=false
readonly paths="
  LICENSE
  README
  *.c
  *.h
"

extract_source () {
    git_archive
    pushd "${extractdir}/${name}-reduced"
    echo "* -whitespace" > .gitattributes
    fromdos dlltest.c
    popd
}

. "${BASH_SOURCE%/*}/update-third-party.bash"
