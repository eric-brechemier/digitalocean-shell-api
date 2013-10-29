#!/bin/sh
# Install the package curl used to query the API

echo 'Install project dependency: curl (using apt-get with sudo)'
sudo apt-get --yes install curl

echo 'Install project dependency: JSON.sh (as a git submodule)'
git submodule init
git submodule update
