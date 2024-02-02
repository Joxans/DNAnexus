#!/usr/bin/env bash

# -- safe bash scripting
set -euf -o pipefail

# -- verbose output mode
VERBOSE="--verbose"
# -- set up encoding/language
export LANG='en_US.UTF-8'
# -- build dirs
BUILD_DIR='build/'
DIST_DIR='dist/'
# -- python/pip commands default aliases
CMD_PYTHON=python3
CMD_PIP=pip3

# - start the script
clear
printf "\nDevelopment Virtual Environment setup is starting...\n\n"
printf "We are here: [%s]\n" "$(pwd)"

# -- setup some commands aliases, depending on the machine type
unameOut="$(uname -s)" # get machine name (short)
# - based on the machine type - setup aliases
case "${unameOut}" in
    Linux*)     MACHINE=Linux; CMD_PYTHON=python3; CMD_PIP=pip3;;
    Darwin*)    MACHINE=Mac; CMD_PYTHON=python3; CMD_PIP=pip3;;
    CYGWIN*)    MACHINE=Cygwin; CMD_PYTHON=python; CMD_PIP=pip;;
    MINGW*)     MACHINE=MinGW; CMD_PYTHON=python; CMD_PIP=pip;;
    *)          MACHINE="UNKNOWN:${unameOut}"; printf "Unknown machine: %s" "${MACHINE}"; exit 1
esac

# -- upgrade pip
printf "\nUpgrading pip.\n"
# pip --no-cache-dir install --upgrade pip  # previous version with pip only
${CMD_PYTHON} -m pip --no-cache-dir install --upgrade pip

# -- upgrading pipenv (just for the case)
printf "\nUpgrading pipenv.\n"
${CMD_PIP} --no-cache-dir install --upgrade pipenv

# -- remove existing virtual environment, clear caches
printf "\nDeleting virtual environment and clearing caches.\n"
pipenv --rm ${VERBOSE} || printf "No virtual environment found for the project!\n"
pipenv --clear ${VERBOSE}

# -- pipenv clean + update
printf "\nPerforming clean + update for pipenv environment.\n"
pipenv clean ${VERBOSE} # uninstalls all packages not specified in Pipfile.lock
pipenv update ${VERBOSE} # runs lock, then sync

# -- clean build and distribution folders
printf "\nClearing temporary directories.\n"
printf "\nDeleting [%s]...\n" ${BUILD_DIR}
rm -r ${BUILD_DIR} || printf "%s doesn't exist!\n" ${BUILD_DIR}
printf "\nDeleting [%s]...\n" ${BUILD_DIR}
rm -r ${DIST_DIR} || printf "%s doesn't exist!\n" ${DIST_DIR}

# -- removing Pipfile.lock (re-generate it)
printf "\nRemoving Pipfile.lock\n"
rm Pipfile.lock || printf "Pipfile.lock doesn't exist!\n"

# -- install all dependencies, incl. development
printf "\nInstalling dependencies, updating all + outdated.\n"
pipenv install --dev ${VERBOSE}

# - check for vulnerabilities and show dependencies graph
printf "\nChecking virtual environment for vulnerabilities.\n"
pipenv check || printf "There are some issues, check logs...\n"
pipenv graph

# - outdated packages report
printf "\n\nOutdated packages list (pip list):\n"
pipenv run pip list --outdated
