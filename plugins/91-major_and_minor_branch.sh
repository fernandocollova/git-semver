#!/bin/bash

function run() {

    current_branch=$(git rev-parse --abbrev-ref HEAD)
    version_new="$1"

    minor_number=$(echo "$version_new" | cut --delimiter="." --fields=2)
    major_number=$(echo "$version_new" | cut --delimiter="." --fields=1)

    git checkout "$major_number.$minor_number" || git checkout -b "$major_number.$minor_number"
    if ! git merge --ff-only
    then
        echo "Minor tag branch cannot be fast forwarded. Aborting."
        return 113
    fi

    git checkout "$major_number" || git checkout -b "$major_number"
    if ! git merge --ff-only
    then
        echo "Major tag branch cannot be fast forwarded. Aborting."
        return 113
    fi

    git checkout "$current_branch"

}

case "${1}" in
    --about)
        echo -n "Merge changes into the minor and major branches of the tag."
        ;;
    *)
        run "$@"
        ;;
esac

