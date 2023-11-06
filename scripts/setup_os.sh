#!/bin/sh
#
# Script for setting up the whole OS for development.

SCRIPT=`realpath $0`
SCRIPT_DIR=`dirname $SCRIPT`
. ${SCRIPT_DIR}/environment.sh || exit 1

. ${SCRIPT_DIR}/setup_folder_hierarchy.sh
. ${SCRIPT_DIR}/setup_bindings.sh
. ${SCRIPT_DIR}/setup_terminal.sh
. ${SCRIPT_DIR}/update_vim.sh
. ${SCRIPT_DIR}/setup_code.sh
. ${SCRIPT_DIR}/install_dev_utils.sh
