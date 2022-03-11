#!/bin/sh
#
# Simple shell library for making assertions and queries
# about the environment or platform.

if ! [ "${ENVIRONMENT_SH_LIB__:-}" ]; then
 declare -i ENVIRONMENT_SH_LIB=0
fi

if (( ENVIRONMENTS_SH_LIB++ == 0 )); then

  environment_os () {
    case $(uname | tr '[:upper:]' '[:lower:]') in
    linux*)
      echo "linux"
      ;;
    darwin*)
      echo "mac"
      ;;
    msys*)
      echo "windows"
      ;;
    *)
      echo "unknown"
      ;;
    esac  
  }

  environment_linux () {
    if [ $(environment_os) = "linux" ]; then
      return 0;
    else
      return 1;
    fi;
  }

  environment_mac () {
    if [ $(environment_os) = "mac" ]; then
      return 0;
    else
      return 1;
    fi;
  }

  environment_windows () {
    if [ $(environment_os) = "windows" ]; then
      return 0;
    else
      return 1;
    fi;
  }

  environment_unknown () {
    if [ $(environment_os) = "unknown" ]; then
      return 0;
    else
      return 1;
    fi;
  }

fi # Include guard