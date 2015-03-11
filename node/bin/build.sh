#!/bin/bash
set -e

if [[ ! -d $INPUT_DIR ]] || [[ ! -d $OUTPUT_DIR ]]; then
  echo "input/output directories must exist"
  exit 1
fi

source /root/.nvm/nvm.sh

# recursively search input directory for a package.json or npm-shrinkwrap.json
PACKAGE_PATH=$(find-package $INPUT_DIR)

if [[ $PACKAGE_PATH ]]; then

  # `get-version` parses input for known versions and picks
  # based on semver compared to package.json (if present)
  # output contains logging, last line is determined version string
  NODE_VERSION=$(nvm ls-remote | get-version --engine node --package $PACKAGE | tail -n 1)
  NPM_VERSION=$(npm view npm --json | get-version --engine npm --package $PACKAGE | tail -n 1)

  echo "nvm install $NODE_VERSION"
  nvm install $NODE_VERSION

  echo "npm install npm@$NPM_VERSION --global"
  npm install npm@$NPM_VERSION --global

  echo "cd ${PACKAGE_PATH%/*} && npm install --production"
  cd ${PACKAGE_PATH%/*}
  npm install --production
fi

echo "cp -R $INPUT_DIR/* $OUTPUT_DIR"
cp -R $INPUT_DIR/* $OUTPUT_DIR
