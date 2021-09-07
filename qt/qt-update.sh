#!/bin/bash

BASE_DIRECTORY=$PWD

set -ex

if [ ! -f "$BASE_DIRECTORY/.qt-lib-update" ]; then
     echo "library update"
     apt update
     apt -y dist-upgrade
     apt-get -y install build-dep libudev-dev libinput-dev libts-dev libxcb-xinerama0-dev libxcb-xinerama0 gdbserver
     apt-get -y install libbluetooth-dev bluez-tools        
     touch $BASE_DIRECTORY/.qt-lib-update
fi

if [ ! -f "/usr/lib/arm-linux-gnueabihf/libEGL.so.1.0.0_backup" ]; then
     mv /usr/lib/arm-linux-gnueabihf/libEGL.so.1.0.0 /usr/lib/arm-linux-gnueabihf/libEGL.so.1.0.0_backup
        ln -s /opt/vc/lib/lbbrcmEGL.so /usr/lib/arm-linux-gnueabihf/libEGL.so.1.0.0
        #ln -s /opt/vc/lib/libEGL.so /usr/lib/arm-linux-gnueabihf/libEGL.so.1.0.0
fi

if [ ! -f "/usr/lib/arm-linux-gnueabihf/libGLESv2.so.2.0.0_backup" ]; then
        mv /usr/lib/arm-linux-gnueabihf/libGLESv2.so.2.0.0 /usr/lib/arm-linux-gnueabihf/libGLESv2.so.2.0.0_backup
        ln -s /opt/vc/lib/lbbrcmGLESv2.so /usr/lib/arm-linux-gnueabihf/libGLESv2.so.2.0.0
        #ln -s /opt/vc/lib/libGLESv2.so /usr/lib/arm-linux-gnueabihf/libGLESv2.so.2.0.0
fi

exit 0
