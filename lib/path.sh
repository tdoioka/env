#!/bin/bash -e

# show current directory path
function current_dir() {
    dirname $(current_file $((${1:-1}+1)))
}
# show current scipt path
function current_file() {
    realpath ${BASH_SOURCE[${1:-1}]}
}
