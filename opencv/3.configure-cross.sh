#!/usr/bin/env bash

BASE_DIRECTORY=/opt/qt5pix
OPENCV_VERSION=4.1.0
BUILD_DIRECTORY=$PWD

set -ex

if [ ! -d "$BUILD_DIRECTORY/opencv/opencv-$OPENCV_VERSION/build" ]; then
    mkdir $BUILD_DIRECTORY/opencv/opencv-$OPENCV_VERSION/build
fi

cd $BUILD_DIRECTORY/opencv/opencv-$OPENCV_VERSION/build

rm -rf *

cmake -D CMAKE_BUILD_TYPE=RELEASE \
         -D CMAKE_INSTALL_PREFIX=$BASE_DIRECTORY/sysroot/usr/local \
         -D CMAKE_TOOLCHAIN_FILE=../platforms/linux/arm-gnueabi.toolchain.cmake \
         -D GCC_COMPILER_VERSION=7 \
         -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-$OPENCV_VERSION/modules \
         -D CMAKE_CXX_COMPILER=/opt/tools/gcc-linaro-7.5.0-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-g++ \
         -D CMAKE_CXX_COMPILER_AR=/opt/tools/gcc-linaro-7.5.0-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-ar \
         -D CMAKE_CXX_COMPILER_RANLIB=/opt/tools/gcc-linaro-7.5.0-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-ranlib \
         -D CMAKE_C_COMPILER=/opt/tools/gcc-linaro-7.5.0-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-gcc \
         -D CMAKE_C_COMPILER_AR=/opt/tools/gcc-linaro-7.5.0-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-ar \
         -D CMAKE_C_COMPILER_RANLIB=/opt/tools/gcc-linaro-7.5.0-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-ranlib \
         -D CMAKE_LINKER=/opt/tools/gcc-linaro-7.5.0-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-ld \
	  ..
#         -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-$OPENCV_VERSION/modules \
#         -D OPENCV_ENABLE_NONFREE=ON \
#         -D INSTALL_C_EXAMPLES=OFF \
#         -D INSTALL_PYTHON_EXAMPLES=OFF \
#         -D BUILD_TESTS=OFF \
#         -D BUILD_DOCS=OFF \
#         -D WITH_GSTREAMER=ON \
#         -D ENABLE_NEON=ON \
#         -D ENABLE_VFPV3=ON \
#         -D WITH_OPENMP=ON \
#         -D BUILD_TIFF=ON \
#         -D WITH_FFMPEG=ON \
#         -D WITH_TBB=ON \
#         -D WITH_V4L=ON \
#         -D WITH_QT=ON \
#         -D Qt5_DIR=$BASE_DIRECTORY/sysroot/usr/local/qt5pi/lib/cmake/Qt5 \
#         -D Qt5Concurrent_DIR=$BASE_DIRECTORY/sysroot/usr/local/qt5pi/lib/cmake/Qt5Concurrent \
#         -D Qt5Core_DIR=$BASE_DIRECTORY/sysroot/usr/local/qt5pi/lib/cmake/Qt5Core \
#         -D Qt5Gui_DIR=$BASE_DIRECTORY/sysroot/usr/local/qt5pi/lib/cmake/Qt5Gui \
#         -D Qt5Test_DIR=$BASE_DIRECTORY/sysroot/usr/local/qt5pi/lib/cmake/Qt5Test \
#         -D Qt5Widgets_DIR=$BASE_DIRECTORY/sysroot/usr/local/qt5pi/lib/cmake/Qt5Widgets \
#         -D Qt5OpenGL_DIR=$BASE_DIRECTORY/sysroot/usr/local/qt5pi/lib/cmake/Qt5OpenGL \
#         -D _qt5gui_OPENGL_INCLUDE_DIR=$BASE_DIRECTORY/sysroot/opt/vc/include \
#         -D BUILD_EXAMPLES=OFF \
#         ..

make && sudo make install
