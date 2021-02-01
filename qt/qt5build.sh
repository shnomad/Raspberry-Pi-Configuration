#!/bin/bash

BASE_DIRECTORY=$PWD
BUILD_DIRECTORY=$BASE_DIRECTORY/qt5build
RASPBERRYPI_ADDRESS=10.42.0.219

#if [ ! -d "$BASE_DIRECTORY/tools" ]; then
#    git clone https://github.com/raspberrypi/tools
#fi

#if [[ :$PATH: == *:"$BASE_DIRECTORY/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin":* ]] ; then
#    echo "Found toolchain in PATH. "
#else
#	echo "Toolchain not found. Export toolchain"
#    export PATH=$PATH:$BASE_DIRECTORY/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin
#fi

if [ ! -f "$BASE_DIRECTORY/qt-everywhere-src-5.12.5.tar.xz" ]; then
	echo "Download qt sources"
    wget http://download.qt.io/official_releases/qt/5.12/5.12.5/single/qt-everywhere-src-5.12.5.tar.xz
fi

if [ ! -d "$BASE_DIRECTORY/qt-everywhere-src-5.12.5" ]; then
	echo "Extract qt sources"
    tar -xf qt-everywhere-src-5.12.5.tar.xz
fi

if [ ! -d "$BASE_DIRECTORY/qt-everywhere-src-5.12.5/qtbase/mkspecs/linux-arm-gnueabihf-g++" ]; then
	echo "Generate hf configuration for qmake"
    cp -R $BASE_DIRECTORY/qt-everywhere-src-5.12.5/qtbase/mkspecs/linux-arm-gnueabi-g++ $BASE_DIRECTORY/qt-everywhere-src-5.12.5/qtbase/mkspecs/linux-arm-gnueabihf-g++
    sed -i -e 's/arm-linux-gnueabi-/arm-linux-gnueabihf-/g' $BASE_DIRECTORY/qt-everywhere-src-5.12.5/qtbase/mkspecs/linux-arm-gnueabihf-g++/qmake.conf
fi

if [ ! -f "$BASE_DIRECTORY/.sysroot" ]; then
	echo "Download sysroot"
	if [ -d "$BASE_DIRECTORY/sysroot" ]; then
		rm -Rf $BASE_DIRECTORY/sysroot
	fi

    mkdir $BASE_DIRECTORY/sysroot $BASE_DIRECTORY/sysroot/usr $BASE_DIRECTORY/sysroot/opt $BASE_DIRECTORY/sysroot/usr/local
    rsync -avz pi@$RASPBERRYPI_ADDRESS:/lib $BASE_DIRECTORY/sysroot
    rsync -avz pi@$RASPBERRYPI_ADDRESS:/usr/include $BASE_DIRECTORY/sysroot/usr
    rsync -avz pi@$RASPBERRYPI_ADDRESS:/usr/lib $BASE_DIRECTORY/sysroot/usr
    rsync -avz pi@$RASPBERRYPI_ADDRESS:/usr/local/lib $BASE_DIRECTORY/sysroot/usr/local
    rsync -avz pi@$RASPBERRYPI_ADDRESS:/usr/local/include $BASE_DIRECTORY/sysroot/usr/local
    rsync -avz pi@$RASPBERRYPI_ADDRESS:/opt/vc $BASE_DIRECTORY/sysroot/opt

    if [ ! -f "$BASE_DIRECTORY/sysroot-relativelinks.py" ]; then
        wget https://raw.githubusercontent.com/riscv/riscv-poky/master/scripts/sysroot-relativelinks.py
        chmod +x $BASE_DIRECTORY/sysroot-relativelinks.py
    fi

    $BASE_DIRECTORY/sysroot-relativelinks.py $BASE_DIRECTORY/sysroot 2>&1 | tee $BASE_DIRECTORY/sysroot-relativelinks.log
    touch $BASE_DIRECTORY/.sysroot
fi

set -o pipefail
set -o errtrace
function error() {
    JOB="$0"
    LASTLINE="$1"
    LASTERR="$2"
    echo "ERROR in ${JOB} : line ${LASTLINE} with exit code ${LASTERR}"
    exit 1
}
trap 'error ${LINENO} ${?}' ERR

if [ ! -d "$BUILD_DIRECTORY" ]; then
    mkdir $BUILD_DIRECTORY
fi

cd $BUILD_DIRECTORY

if [ ! -f "$BASE_DIRECTORY/.configure" ]; then
    $BASE_DIRECTORY/qt-everywhere-src-5.12.5/configure -opengl es2 -device linux-rasp-pi3-g++ -device-option CROSS_COMPILE=/opt/tools/gcc-linaro-7.5.0-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf- -sysroot $BASE_DIRECTORY/sysroot -prefix /usr/local/qt5pi -opensource -confirm-license -skip qtscript -nomake tests -nomake examples -make libs -no-gbm -pkg-config -no-use-gold-linker -v 2>&1 | tee $BASE_DIRECTORY/configure.log
    touch $BASE_DIRECTORY/.configure
fi

if [ ! -f "$BASE_DIRECTORY/.make" ]; then
    make 2>&1 | tee $BASE_DIRECTORY/make.log
    touch $BASE_DIRECTORY/.make
fi

if [ ! -f "$BASE_DIRECTORY/.make_install" ]; then
    make install 2>&1 | tee $BASE_DIRECTORY/make_install.log
    touch $BASE_DIRECTORY/.make_install
fi

cd $BASE_DIRECTORY

if [ ! -f "$BASE_DIRECTORY/.upload" ]; then
    rsync -avz $BASE_DIRECTORY/sysroot/usr/local/qt5pi pi@$RASPBERRYPI_ADDRESS:/usr/local
    touch $BASE_DIRECTORY/.upload
fi

exit 0
