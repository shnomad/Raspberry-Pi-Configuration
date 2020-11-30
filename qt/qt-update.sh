#!/bin/bash

BASE_DIRECTORY=$PWD

set -ex

if [ ! -f "$BASE_DIRECTORY/.qt-lib-update" ]; then
     echo "library update"
     apt update
     apt -y dist-upgrade
     apt-get -y build-dep qt5-qmake libqt5gui5 libqt5webengine-data libqt5webkit5
     apt-get -y install libudev-dev libinput-dev libxcb-xinerama0-dev libxcb-xinerama0 gdbserver
     touch $BASE_DIRECTORY/.qt-lib-update
fi

