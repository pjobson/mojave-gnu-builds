#!/bin/bash

if [ "$(id -u)" -eq 0 ]; then
        echo 'This script must NOT be run by root!' >&2
        exit 1
fi

xcode-select --install

sudo mkdir -p /opt

mkdir -p ~/.local/bin
mkdir ~/code
cd ~/code

# Add to ~/.profile
echo "export DYLD_LIBRARY_PATH=/opt/lib" >> ~/.profile
echo "export LD_LIBRARY_PATH=/opt/lib" >> ~/.profile
echo "export PATH=/opt/bin:\$PATH" >> ~/.profile

source ~/.profile

echo "source ~/.profile" >> ~/.bashrc

