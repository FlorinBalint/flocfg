#!/bin/sh
#
# Simple script for overriding your .vimrc with the one
# found in the /configs folder of the repository.

script_dir="$(dirname "$0")"
VIMRC_FILE="${script_dir}/../configs/.vimrc"
cp ${VIMRC_FILE} ${HOME}
