#!/bin/sh
#
# Script for installing the basic utils needed for development.
# This includes tools like package managers, language SDKs, text processing
# and other common development tools.

SCRIPT=`realpath $0`
SCRIPT_DIR=`dirname $SCRIPT`
source ${SCRIPT_DIR}/environment.sh || exit 1

setup_c() {
  if environment_mac; then
    if [ ! $(xcode-select -p) ]; then
      xcode-select --install
    fi
    xcodebuild -runFirstLaunch
  elif environment_linux; then
    sudo apt install build-essential
    sudo apt-get install manpages-dev
  else
    exit "script only works for linux and mac OS"
  fi
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

  mkdir -p /Users/${USER}/Work/Repos/go/{bin,src,pkg}
  mkdir -p $GOPATH/src/github.com/FlorinBalint
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

setup_mac_utils() {
  # Install Homebrew if needed
  if [ $(command -v brew) == "" ]; then
    echo "Homebrew is already installed"
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  brew install coreutils
  brew install bazel
  brew install gmsh
  brew install git
  brew install docker
  brew install kubectl
  brew install helm
  brew install gh
  brew install protobuf
  brew install gradle
}

setup_linux_utils() {
  sudo apt update -y
  sudo apt install -y coreutils
  sudo apt-get install gmsh -y
  sudo apt intsall -y git
  sudo apt-get install docker-ce docker-ce-cli containerd.io

  if [ $(kubectl version --client) ]; then
    echo "kubectl is already installed"
  else
    # Install kubectl
    sudo apt-get install -y apt-transport-https ca-certificates curl
    sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get install -y kubectl
  fi

  if [ $(helm version) ]; then
    echo "helm is already installed"
  else
    # Install helm
    curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
    sudo apt-get install apt-transport-https --yes
    echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    sudo apt-get update
    sudo apt-get install helm
  fi

  if [ $(gradle --version)]; then
    echo "gradle is already installed"
  else # install gradle
    wget https://services.gradle.org/distributions/gradle-5.0-bin.zip -P /tmp
    sudo unzip -d /opt/gradle /tmp/gradle-*.zip
    sudo cat >/etc/profile.d/gradle.sh << EOF `
export GRADLE_HOME=/opt/gradle/gradle-5.0
export PATH=${GRADLE_HOME}/bin:${PATH}
`
EOF
  fi

  if [ $(gh --version)]; then
    echo "Github CLI already installed"
  else # install github CLI
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | 
      sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install gh
  fi

  if [ $(protoc -version) ]; then
    echo "Protobuffer tools already installed"
  else 
    PROTOC_ZIP=protoc-3.14.0-linux-x86_64.zip
    curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v3.14.0/$PROTOC_ZIP
    sudo unzip -o $PROTOC_ZIP -d /usr/local bin/protoc
    sudo unzip -o $PROTOC_ZIP -d /usr/local 'include/*'
    rm -f $PROTOC_ZIP
  fi

  if [ $(bazel --version) ]; then
    echo "Bazel is already installed"
  else
    sudo apt install apt-transport-https curl gnupg
    curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor >bazel-archive-keyring.gpg
    sudo mv bazel-archive-keyring.gpg /usr/share/keyrings
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8" \
       | sudo tee /etc/apt/sources.list.d/bazel.list
    sudo apt update && sudo apt install bazel
  fi

  sudo apt update && sudo apt full-upgrade
}

if environment_mac; then
  setup_mac_utils
elif environment_linux; then
  setup_linux_utils
else
  exit "script only works for linux and mac OS"
fi

setup_c
setup_golang
setup_java
setup_python
