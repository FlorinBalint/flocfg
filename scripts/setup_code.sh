#!/bin/sh

script_dir="$(dirname "$0")"
source ${script_dir}/environment.sh || exit 1

function install_vscode() {
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

function install_vscode_extensions() {
  extensions="
CyriacduChatenet.monterey-dark-theme
Equinusocio.vsc-community-material-theme
Equinusocio.vsc-material-theme
equinusocio.vsc-material-theme-icons
dbaeumer.vscode-eslint
donjayamanne.githistory
mhutchie.git-graph
Dart-Code.dart-code
Dart-Code.flutter
golang.go
ecmel.vscode-html-css
formulahendry.auto-rename-tag
googlecloudtools.cloudcode
k--kato.intellij-idea-keybindings
ms-azuretools.vscode-docker
ms-dotnettools.csharp
ms-kubernetes-tools.vscode-kubernetes-tools
ms-python.python
ms-python.vscode-pylance
ms-toolsai.jupyter
ms-toolsai.jupyter-keymap
ms-toolsai.jupyter-renderers
ms-vscode.cpptools
ms-vscode.hexeditor
PKief.material-icon-theme
redhat.java
redhat.vscode-yaml
ryuta46.multi-command
VisualStudioExptTeam.vscodeintellicode
vscjava.vscode-java-debug
vscjava.vscode-java-dependency
vscjava.vscode-java-pack
vscjava.vscode-java-test
vscjava.vscode-maven
Zignd.html-css-class-completion
"

  for extension in ${extensions}; do
    code --install-extension "${extension}"
  done
}

function edit_vscode_settings() {
   if environment_mac; then
     cp ${script_dir}/../dotfiles/vscode/settings.json "${HOME}/Library/Application Support/Code/User"
     cp ${script_dir}/../dotfiles/vscode/keybindings.json "${HOME}/Library/Application Support/Code/User"
   elif environment_linux; then
     cp ${script_dir}/../dotfiles/vscode/settings.json "${HOME}/.config/Code/User"
     cp ${script_dir}/../dotfiles/vscode/keybindings.json "${HOME}/.config/Code/User"
   else
     exit "script only works for linux and mac OS"
   fi
}

install_vscode
install_vscode_extensions
edit_vscode_settings