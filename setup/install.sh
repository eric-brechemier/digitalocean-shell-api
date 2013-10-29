#!/bin/sh
# Install the package curl used to query the API

echo 'Install project dependency: curl (using apt-get with sudo)'
sudo apt-get --yes install curl

echo 'Install project dependency: JSON.sh (as a git submodule)'
git submodule init
git submodule update

echo 'Switch to the root of the project'
cd "$(dirname $0)"
cd ..

echo 'Create template file for the configuration: config.sh'
cat << EOF | tee config.sh
# Configuration of Identification for DigitalOcean API

# Client ID
CLIENT_ID=

# API Key
API_KEY=
EOF
