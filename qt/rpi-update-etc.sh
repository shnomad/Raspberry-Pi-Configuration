#!/bin/bash

BASE_DIRECTORY=$PWD

set -ex

echo "INSTALL UTILITY"
sudo apt update
sudo apt -y install libhidapi-hidraw0 libhidapi-libusb0 automake libtool git wiringpi
sudo cp hidapi.h /usr/include

echo "INSTALL USB Power controller"
git clone https://github.com/mvp/uhubctl

cd uhubctl
make && sudo make install

echo "INSTALL TSLIB"
cd $BASE_DIRECTORY

git clone git://github.com/kergoth/tslib.git

cd tslib
./autogen.sh
./configure

make && sudo make install
