#!/bin/bash
set -e
set -x

# overwrite env from base image
export HOME=/root
export TEMP_DIR=/tmp
export TMPDIR=/tmp
export TMP_DIR=/tmp

#install dependent libraries
apt-get update && apt-get install -y libssl0.9.8 libsqlite-dev libexpat1 \
  libexpat1-dev libicu-dev libpq-dev libcairo2-dev libjpeg8-dev \
  libpango1.0-dev libgif-dev libxml2-dev libmagickcore-dev libmagickwand-dev \
  libkrb5-dev

# Install ImageMagick
export MAKEFLAGS="-j $(grep -c ^processor /proc/cpuinfo)"
cd /opt
wget http://www.imagemagick.org/download/ImageMagick.tar.gz
tar -xf ImageMagick.tar.gz && mv ImageMagick-* ImageMagick && cd ImageMagick && ./configure && make && sudo make install
ldconfig /usr/local/lib && rm -rf /opt/ImageMagick*
cd /opt

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
apt-get autoclean && apt-get autoremove -y && apt-get clean
