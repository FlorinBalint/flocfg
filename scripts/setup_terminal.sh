#!/bin/sh
#
# Script for setting up the terminal app and the required configurations.
# The script starts by installing zsh and configuring it, before it proceeds with:
#  * installing the Terminator app for linux (TODO: Configure)
#  * installing and configuring the iterm2 app for macOS

SCRIPT=`realpath $0`
SCRIPT_DIR=`dirname $SCRIPT`
. ${SCRIPT_DIR}/environment.sh || exit 1

get_fonts() {
  local fonts_dir
  if environment_mac; then
    fonts_dir="${HOME}/Library/fonts"
  elif environment_linux; then
    fonts_dir="${HOME}/.fonts"
  else 
    exit "script only works for linux and macOS"
  fi

  mkdir -p ${fonts_dir}
  if [ $(ls ${fonts_dir} | grep "Menlo.*Powerline.ttf" | wc -l) -ne 4 ]; then
    echo "Installing Menlo for Powerline font"
    cd ${HOME}/Work/Repos && git clone https://github.com/abertsch/Menlo-for-Powerline.git
    find ${HOME}/Work/Repos/Menlo-for-Powerline -iname "*ttf" -exec cp -- "{}" ${fonts_dir} \;
    set guifont="Menlo for Powerline"
    fc-cache -vf "${fonts_dir}"
  else
    echo "Menlo for Powerline is already installed"
  fi  
}

setup_iterm() {
  if [ -z "$(brew info iterm2)" ]; then
    echo "Installing iterm2"
    brew install --cask iterm2
  else
    echo "iterm2 is already installed"  
  fi
  iterm2_profile="${HOME}/Library/Application Support/iTerm2/DynamicProfiles/Florin.json"
  if [ -f "${iterm2_profile}" ]; then
    echo "Florin iterm2 profile already exists"
  else
    echo "Creating Florin iterm2 profile"
    cp "${SCRIPT_DIR}/../configs/iterm2.json" "${iterm2_profile}"
    escaped_home=$(echo $HOME | sed "s/\//\\\\\\\\\\\\\//g")
    sed "s/\%HOME\%/${escaped_home}/g" "${iterm2_profile}"
  fi
}

setup_terminator() {
  sudo apt-get install terminator
  # TODO(florinbalint): configure the app
}

setup_omzsh() {
  omz_script_url="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
  if [ -d ~/.oh-my-zsh ]; then
    echo "Oh My ZSH already installed"
  else
    echo "Installing Oh My ZSH"
    ( 
      RUNZSH=no zsh -c "$(curl -fsSL ${omz_script_url})"
      omz update
    )  
  fi
}

get_fonts

if environment_linux; then
  which zsh&>/dev/null || sudo apt-get install zsh -y
  chsh -s /usr/bin/zsh # Make zsh default
  setup_terminator
  setup_omzsh
elif environment_mac; then
  setup_iterm
  setup_omzsh
else
  exit "script only works for linux and macOS"
fi

cp ${SCRIPT_DIR}/../configs/.zshrc ${HOME}
cp ${SCRIPT_DIR}/../configs/.zsh_aliases ${HOME}
