#!/bin/sh
#
# Simple script for updating the key Mac bindings to to more
# match the default behavior on Windows / Linux systems.
# The script assumes that you already reversed cmd <-> ctrl.

script_dir="$(dirname "$0")"
source ${script_dir}/environment.sh || exit 1

WINDOWS_BINDINGS_FILE="${script_dir}/../configs/DefaultKeyBinding.Dict"

if environment_mac; then
  mkdir -p ${HOME}/Library/KeyBindings/
  cp ${WINDOWS_BINDINGS_FILE} ${HOME}/Library/KeyBindings
fi
