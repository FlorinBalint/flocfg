#!/bin/sh

script_dir="$(dirname "$0")"
VIMRC_FILE="${script_dir}/../configs/.vimrc"
cp ${VIMRC_FILE} ${HOME}
