#!/bin/sh
#
# Script for installing and configuring VS Code to the prefered look & behaviour.
# The script sets the keybindings and settings by overriding the existing ones
# (if any) with the config files found in the configs/vscode repository folder.

SCRIPT=`realpath $0`
SCRIPT_DIR=`dirname $SCRIPT`
source ${SCRIPT_DIR}/environment.sh || exit 1

install_vscode() {
  if $(environment_mac); then
    brew install --cask visual-studio-code
  elif $(environment_linux); then
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    sudo apt install code
    sudo apt update
    sudo apt upgrade
  else
    exit "script only works for linux and mac OS"
  fi
}

install_vscode_extensions() {
  extensions=$( less ${SCRIPT_DIR}/../configs/vscode/extensions.txt) 

  for extension in ${extensions}; do
    code --install-extension "${extension}"
  done
}

edit_vscode_settings() {
   if environment_mac; then
     cp ${SCRIPT_DIR}/../configs/vscode/settings.json "${HOME}/Library/Application Support/Code/User"
     cp ${SCRIPT_DIR}/../configs/vscode/keybindings.json "${HOME}/Library/Application Support/Code/User"
   elif environment_linux; then
     cp ${SCRIPT_DIR}/../configs/vscode/settings.json "${HOME}/.config/Code/User"
     cp ${SCRIPT_DIR}/../configs/vscode/keybindings.json "${HOME}/.config/Code/User"
   else
     exit "script only works for linux and mac OS"
   fi
}

install_vscode
install_vscode_extensions
edit_vscode_settings