#!/bin/bash

# Common snippets that are nice to use in scripts
# NOTE: This is for reference only... It's best to copy paste any required functions into the
# script that needs it so that each script is self-contained. (easier for running on a remote server for example)


function heading() {
    echo "-------"
    printf "\033[1;32m %s \033[0m \n" "$1"
    echo "-------"
}

function warning() {
    echo "-------"
    printf "\033[1;33m WARNING: %s \033[0m \n" "$1"
    echo "-------"
}
