#!/usr/bin/env bash
BASE_DIRECTORY=$PWD
OPENCV_VERSION=4.1.0
set -ex

mkdir -p $BASE_DIRECTORY/opencv && pushd $BASE_DIRECTORY/opencv
wget -O opencv.zip "https://github.com/opencv/opencv/archive/{OPENCV_VERSION}.zip"
wget -O opencv_contrib.zip "https://github.com/opencv/opencv_contrib/archive/{OPENCV_VERSION}.zip"
unzip "opencv-${OPENCV_VERSION}.zip"
unzip "opencv_contrib-${OPENCV_VERSION}.zip"
popd
