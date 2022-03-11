#!/bin/sh

script_dir="$(dirname "$0")"
source ${script_dir}/environment.sh || exit 1

WINDOWS_BINDINGS_FILE="${script_dir}/../configs/DefaultKeyBinding.Dict"

if environment_mac; then
  mkdir -p ${HOME}/Library/KeyBindings/
  cp ${WINDOWS_BINDINGS_FILE} ${HOME}/Library/KeyBindings
fi
