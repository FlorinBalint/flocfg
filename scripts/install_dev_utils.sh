#!/bin/sh
#
# Script for installing the basic utils needed for development.
# This includes tools like package managers, language SDKs, text processing
# and other common development tools.

SCRIPT=`realpath $0`
SCRIPT_DIR=`dirname $SCRIPT`
source ${SCRIPT_DIR}/environment.sh || exit 1

install_homebrew() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

setup_golang() {
  if environment_mac; then
    brew update && brew install golang
    export GOROOT="$(brew --prefix golang)/libexec"
  elif environment_linux; then
    add-apt-repository ppa:ubuntu-lxc/stable
    sudo apt-get update
    sudo apt-get -y upgrade
    sudo apt-get install golang
  else
    exit "script only works for linux and mac OS"
  fi  

  mkdir -p $HOME/go/{bin,src,pkg}
  export GOPATH=$HOME/go
  export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
}

setup_java() {
  if environment_mac; then
    brew cask install java
  elif environment_linux; then
    sudo apt install default-jre
    sudo apt install default-jdk
  else
    exit "script only works for linux and mac OS"
  fi
}

setup_python() {
  if environment_mac; then
    brew install python@3.10
  elif environment_linux; then
    sudo apt-get install python3
  else
    exit "script only works for linux and mac OS"
  fi
}

if environment_mac; then
  install_homebrew
  brew install coreutils
  brew install gmsh
  brew install git
  brew install docker
  brew install kubectl
  brew install helm
elif environment_linux; then
  sudo apt update -y
  sudo apt install -y coreutils
  sudo apt-get install gmsh -y
  sudo apt intsall -y git
  sudo apt-get install docker-ce docker-ce-cli containerd.io
  ( # Install kubectl
    sudo apt-get install -y apt-transport-https ca-certificates curl
    sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get install -y kubectl
  )
  ( # Install helm
    curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
    sudo apt-get install apt-transport-https --yes
    echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    sudo apt-get update
    sudo apt-get install helm
  )
else
  exit "script only works for linux and mac OS"
fi

setup_golang
setup_java
setup_python
