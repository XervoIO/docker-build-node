#!/bin/bash
set -e
set -x

# overwrite env from base image
export HOME=/root
export TEMP_DIR=/root/tmp

# install nvm
export NVM_DIR=/opt/nvm
mkdir -p $NVM_DIR
curl https://raw.githubusercontent.com/creationix/nvm/v0.23.3/install.sh | bash

# ensure mop can use nvm, but not write to it
chown mop:mop /opt/nvm/nvm.sh
chmod g-w /opt/nvm/nvm.sh

# install get-version
npm install -g get-version
