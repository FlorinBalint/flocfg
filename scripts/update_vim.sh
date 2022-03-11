#!/bin/sh
#
# Simple script for overriding your .vimrc with the one
# found in the /configs folder of the repository.

SCRIPT=`realpath $0`
SCRIPT_DIR=`dirname $SCRIPT`
VIMRC_FILE="${SCRIPT_DIR}/../configs/.vimrc"
cp ${VIMRC_FILE} ${HOME}
