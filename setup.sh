#!/bin/bash

xcode-select --install

mkdir -p ~/.local/bin
mkdir ~/code
cd ~/code

# Add to ~/.profile
echo "export DYLD_LIBRARY_PATH=/opt/lib" >> ~/.profile
echo "export LD_LIBRARY_PATH=/opt/lib" >> ~/.profile
echo "export PATH=/opt/bin:\$PATH" >> ~/.profile

source ~/.profile


