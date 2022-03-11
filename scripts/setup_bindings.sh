#!/bin/sh
#
# Simple script for updating the key Mac bindings to to more
# match the default behavior on Windows / Linux systems.
# The script assumes that you already reversed cmd <-> ctrl.

SCRIPT=`realpath $0`
SCRIPT_DIR=`dirname $SCRIPT`
source ${SCRIPT_DIR}/environment.sh || exit 1

WINDOWS_BINDINGS_FILE="${SCRIPT_DIR}/../configs/DefaultKeyBinding.Dict"

if environment_mac; then
  mkdir -p ${HOME}/Library/KeyBindings/
  cp ${WINDOWS_BINDINGS_FILE} ${HOME}/Library/KeyBindings
fi
