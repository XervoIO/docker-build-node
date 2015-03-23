#!/bin/bash
set -e

if [[ ! $INPUT_DIR ]] || [[ ! $OUTPUT_DIR ]]; then
  echo "input/output directory variables must be set"
  exit 1
fi

mkdir -p $INPUT_DIR
mkdir -p $OUTPUT_DIR

if [[ ! -d $INPUT_DIR ]] || [[ ! -d $OUTPUT_DIR ]]; then
  echo "input/output directories must exist"
  exit 1
fi

CURRENT_DIR=$(pwd)

source /root/.nvm/nvm.sh
# source /usr/local/opt/nvm/nvm.sh

# recursively search input directory for a package.json
PACKAGE_PATH=$(find-package $INPUT_DIR)

if [[ $PACKAGE_PATH ]]; then
  printf "package found: $PACKAGE_PATH\n"

  # `get-version` parses input for known versions and picks
  # based on semver compared to package.json (if present)
  # output contains logging, last line is determined version string
  NODE_VERSION=$(nvm ls-remote | get-version --engine node --package $PACKAGE_PATH | tail -n 1)
  if [[ ! $NODE_VERSION ]]; then
    echo "unable to determine node version"
    exit 1
  fi

  NPM_VERSION=$(npm view npm --json | get-version --engine npm --package $PACKAGE_PATH | tail -n 1)
  if [[ ! $NPM_VERSION ]]; then
    echo "unable to determine npm version"
    exit 1
  fi

  printf "\n> nvm install $NODE_VERSION\n"
  nvm install $NODE_VERSION

  if [[ $FORCE_NPM_INSTALL ]]; then
    npm uninstall npm --global
    curl -L https://npmjs.com/install.sh | sh
  fi

  printf "\n> npm install npm@$NPM_VERSION --global\n"
  npm install npm@$NPM_VERSION --global

  printf "\n> cd ${PACKAGE_PATH%/*} && npm install --production\n"
  if [[ -f ${PACKAGE_PATH%/*}/npm-shrinkwrap.json ]]; then
    printf "WARN: npm-shrinkwrap.json will override dependencies declared in package.json.\n"
  fi
  cd ${PACKAGE_PATH%/*}
  npm install --production --loglevel info
fi

printf "\n> cp -R $INPUT_DIR/* $OUTPUT_DIR\n"
cd $CURRENT_DIR
cp -R $INPUT_DIR/* $OUTPUT_DIR
