#!/usr/bin/env bash
BASE_DIRECTORY=$PWD
OPENCV_VERSION=4.1.0
set -ex

mkdir -p $BASE_DIRECTORY/opencv && pushd $BASE_DIRECTORY/opencv
wget -O "opencv-${OPENCV_VERSION}.tar.gz" "https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.tar.gz" 
wget -O "opencv_contrib-${OPENCV_VERSION}.tar.gz" "https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.tar.gz"
tar -xvf "opencv-${OPENCV_VERSION}.tar.gz"
tar -xvf "opencv_contrib-${OPENCV_VERSION}.tar.gz"
popd
