#!/usr/bin/env bash

BASIC_DIRECTORY=$PWD
OPENCV_VERSION=4.1.0

set -ex

cd $BASIC_DIRECTORY/opencv/opencv-$OPENCV_VERSION/build

if [[
$MEM -ge 3000 ]]; then
  NUM_JOBS=$(nproc)
else
  NUM_JOBS=1
fi

sudo sed -i 's/CONF_SWAPSIZE=100/CONF_SWAPSIZE=1024/g' /etc/dphys-swapfile
sudo /etc/init.d/dphys-swapfile stop
sudo /etc/init.d/dphys-swapfile start

make -j "$NUM_JOBS"
sudo make install
sudo sed -i 's/CONF_SWAPSIZE=1024/CONF_SWAPSIZE=100/g' /etc/dphys-swapfile
sudo /etc/init.d/dphys-swapfile stop
sudo /etc/init.d/dphys-swapfile start

echo "sudo modprobe bcm2835-v4l2" >> ~/.profile

popd; popd
