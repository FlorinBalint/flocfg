#!/bin/sh
#
# Script for creating the default folder hierarchy on a new
# unix/linux working station.

make_learn_folder() {
    local LANGS="c cpp java go js ts python bash"
    local FWORKS="spring angular react flutter"

    for dir in ${LANGS} ${FWORKS}
    do
        mkdir -p ${HOME}/Work/Learn/${dir}
    done
}

make_learn_folder

mkdir -p ${HOME}/Pictures
mkdir -p ${HOME}/Work/repos
mkdir -p ${HOME}/Work/logs
mkdir -p ${HOME}/Work/kits
mkdir -p ${HOME}/Work/scripts
mkdir -p ${HOME}/Work/books

mkdir -p ${HOME}/bills
