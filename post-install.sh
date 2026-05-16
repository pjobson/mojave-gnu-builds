#!/bin/bash

if [ "$(id -u)" -eq 0 ]; then
        echo 'This script must NOT be run by root!' >&2
        exit 1
fi

echo "MANDATORY_MANPATH /opt/share/man" >> ~/.manpath

echo "export SSL_CERT_FILE=/opt/ssl/certs/cacert.pem" >> ~/.profile

sudo ln -s /opt/bin/wget2 /opt/bin/wget

sudo ln -sf libtoolize /opt/bin/glibtoolize
sudo ln -sf libtoolize ~/.local/bin/glibtoolize

ln -sf /opt/bin/libtoolize ~/.local/bin/glibtoolize
ln -sf /opt/bin/libtool    ~/.local/bin/glibtool

sudo ln -s /opt/bin/python3.14 /opt/bin/python
sudo ln -s /opt/bin/python3.14 /opt/bin/python3

source ~/.profile

sudo /opt/bin/ssh-keygen -v -A

