#!/bin/bash
set -e
set -x

# overwrite env from base image
export HOME=/root
export TEMP_DIR=/root/tmp

#install dependent libraries
apt-get update && apt-get install -y libssl0.9.8 libsqlite-dev libexpat1 libexpat1-dev libicu-dev libpq-dev libcairo2-dev libjpeg8-dev libpango1.0-dev libgif-dev libxml2-dev

# install nvm
export NVM_DIR=/opt/nvm
mkdir -p $NVM_DIR
curl https://raw.githubusercontent.com/creationix/nvm/v0.23.3/install.sh | bash

# ensure mop can use nvm, but not write to it
chown mop:mop /opt/nvm/nvm.sh
chmod g-w /opt/nvm/nvm.sh

# install get-version
npm install -g get-version

# Clean stuff up that's no longer needed
apt-get autoclean && apt-get autoremove && apt-get clean