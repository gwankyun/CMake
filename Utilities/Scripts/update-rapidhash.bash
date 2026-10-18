#!/usr/bin/env bash

set -e
set -x
shopt -s dotglob

readonly name="rapidhash"
readonly ownership="rapidhash upstream <kwrobot@kitware.com>"
readonly subtree="Utilities/cmrapidhash"
readonly repo="https://github.com/Nicoshev/rapidhash.git"
readonly tag="rapidhash_v3"
readonly shortlog=false
readonly exact_tree_match=false
readonly paths="
  LICENSE
  rapidhash.h
"

extract_source () {
    git_archive
    pushd "${extractdir}/${name}-reduced"
    echo "* -whitespace" > .gitattributes
    fromdos rapidhash.h
    chmod a-x rapidhash.h
    popd
}

. "${BASH_SOURCE%/*}/update-third-party.bash"
