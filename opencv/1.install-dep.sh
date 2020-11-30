#!/usr/bin/env bash
set -ex

#Madatory Part
sudo apt-get -y update

# compiler and build tools
sudo apt-get -y install git build-essential cmake pkg-config checkinstall

# development files for system wide image codecs
sudo apt-get -y install libjpeg-dev libpng-dev libtiff-dev

# Protobuf library and tools for dnn module
sudo apt-get -y install libprotobuf-dev protobuf-compiler

# development files for V4L2 to enable web cameras support in videoio module
sudo apt-get -y install libv4l-dev

#Optional part

# FFmpeg development files to enable video decoding and encoding in videoio module
sudo apt-get -y install libavcodec-dev libavformat-dev libswscale-dev

# development files for GTK 2.0 UI library for highgui module
sudo apt-get -y install libgtk2.0-dev

# Eigen library needed for some modules in contrib repository
sudo apt-get -y install libeigen3-dev

# Numpy and Python3 development files for Python bindings
sudo apt-get -y install python3-dev python3-pip
sudo -H pip3 install numpy
