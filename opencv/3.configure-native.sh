#!/usr/bin/env bash
OPENCV_VERSION=4.1.0
BASE_DIRECTORY=$PWD

set -ex

if [ ! -d "$BASE_DIRECTORY/opencv/opencv-$OPENCV_VERSION/build" ]; then
    mkdir $BASE_DIRECTORY/opencv/opencv-$OPENCV_VERSION/build
fi

cd $BASE_DIRECTORY/opencv/opencv-$OPENCV_VERSION/build

rm -rf *

cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D OPENCV_EXTRA_MODULES_PATH=$BASE_DIRECTORY/opencv/opencv_contrib-$OPENCV_VERSION/modules \
      -D INSTALL_C_EXAMPLES=OFF \
      -D INSTALL_PYTHON_EXAMPLES=OFF \
      -D WITH_GSTREAMER=ON \
      -D ENABLE_NEON=ON \
      -D ENABLE_VFPV3=ON \
      -D WITH_OPENMP=ON \
      -D BUILD_TIFF=ON \
      -D WITH_FFMPEG=ON \
      -D WITH_TBB=ON \
      -D WITH_V4L=ON \
      -D WITH_GTK=ON \
      -D WITH_QT=ON \
      -D BUILD_EXAMPLES=OFF ..

#make && sudo make install
