#!/bin/sh
# Uninstall the package curl used to query the API

echo 'Uninstall project dependency: curl (using sudo)'
sudo apt-get --yes purge curl
sudo apt-get --yes autoremove
