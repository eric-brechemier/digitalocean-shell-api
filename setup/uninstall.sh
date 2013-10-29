#!/bin/sh
# Uninstall the package curl used to query the API

echo 'Uninstall project dependency: curl (using sudo)'
sudo apt-get --yes purge curl
sudo apt-get --yes autoremove

echo 'Switch to the root of the project'
cd "$(dirname $0)"
cd ..

echo 'Delete configuration file with secret Client ID and API Key'
rm config.sh

