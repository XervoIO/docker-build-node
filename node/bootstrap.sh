#!/bin/bash
set -e

# install nvm
curl https://raw.githubusercontent.com/creationix/nvm/v0.23.3/install.sh | bash
source ~/.nvm/nvm.sh

# install node 0.10.x
nvm install 0.10
nvm alias default 0.10
