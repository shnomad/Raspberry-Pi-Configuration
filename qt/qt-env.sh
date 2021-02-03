#!/bin/bash

BASE_DIRECTORY=$PWD

set -ex

if [ ! $(id -u) -eq 0 ]; then
     echo "ERROR: This program must run as root"
     exit 1
fi

if [ ! -f "$BASE_DIRECTORY/.qt-sources.list" ]; then
     echo "change sources list"
     mv /etc/apt/sources.list /etc/apt/sources.list.bak

cat > "/etc/apt/sources.list" << EOF
deb http://raspbian.raspberrypi.org/raspbian/ buster main contrib non-free rpi
# Uncomment line below then 'apt-get update' to enable 'apt-get source'
deb-src http://raspbian.raspberrypi.org/raspbian/ buster main contrib non-free rpi
EOF

  touch $BASE_DIRECTORY/.q-sources.list
fi

if [ ! -f "$BASE_DIRECTORY/.qt-directory" ]; then
     echo "create qt install directory"
     mkdir /usr/local/qt5pi
     chown -R pi:pi /usr/local/qt5pi

     touch $BASE_DIRECTORY/.qt-directory
fi

if [ ! -f "$BASE_DIRECTORY/.qt-profile" ]; then
     echo "create qt profile"

sudo cat > "/etc/profile.d/qt_eglfs.sh" << EOF
#export QT_LOGGING_RULES="*.debug=true"
#export QT_QPA_EGLFS_NO_LIBINPUT=1
#export QT_QPA_EVDEV_TOUCHSCREEN_PARAMETERS=/dev/input/event0:rotate=90
#export QT_QPA_EGLFS_DISABLE_INPUT=1
#export QT_DEBUG_PLUGINS=1
export LD_LIBRARY_PATH=/usr/local/qt5pi/lib
export QT_PLUGIN_PATH=/usr/local/qt5pi/plugins
export QT_QPA_FONTDIR=/usr/lib/fonts
export QT_QPA_PLATFORM_PLUGIN_PATH=/usr/local/qt5pi/plugins/platforms

export QT_QPA_PLATFORM=linuxfb
export QT_QPA_GENERIC_PLUGINS=tslib:/dev/input/event0
export QT_QPA_EVDEV_TOUCHSCREEN_PARAMETERS=/dev/input/event0:rotate=90
export TSLIB_TSEVENTTYPE='INPUT'
export TSLIB_CALIBFILE='/etc/pointercal'
export TSLIB_CONFFILE='/etc/ts.conf'
export TSLIB_CONSOLEDEVICE='none'
export TSLIB_FBDEVICE='/dev/fb0'
export TSLIB_PLUGINDIR='/usr/local/lib/ts'
export TSLIB_TSDEVICE='/dev/input/event0'
EOF

sudo cat > "/root/.bashrc" << EOF
#export QT_LOGGING_RULES="*.debug=true"
#export QT_QPA_EGLFS_NO_LIBINPUT=1
#export QT_QPA_EVDEV_TOUCHSCREEN_PARAMETERS=/dev/input/event0:rotate=90
#export QT_QPA_EGLFS_DISABLE_INPUT=1
#export QT_DEBUG_PLUGINS=1
export LD_LIBRARY_PATH=/usr/local/qt5pi/lib
export QT_PLUGIN_PATH=/usr/local/qt5pi/plugins
export QT_QPA_FONTDIR=/usr/lib/fonts
export QT_QPA_PLATFORM_PLUGIN_PATH=/usr/local/qt5pi/plugins/platforms

export QT_QPA_PLATFORM=linuxfb
export QT_QPA_GENERIC_PLUGINS=tslib:/dev/input/event0
export QT_QPA_EVDEV_TOUCHSCREEN_PARAMETERS=/dev/input/event0:rotate=90
export TSLIB_TSEVENTTYPE='INPUT'
export TSLIB_CALIBFILE='/etc/pointercal'
export TSLIB_CONFFILE='/etc/ts.conf'
export TSLIB_CONSOLEDEVICE='none'
export TSLIB_FBDEVICE='/dev/fb0'
export TSLIB_PLUGINDIR='/usr/local/lib/ts'
export TSLIB_TSDEVICE='/dev/input/event0'
EOF

  touch $BASE_DIRECTORY/.qt-profile
fi

if [ ! -f "$BASE_DIRECTORY/.4inch-lcd-touch-config" ]; then

echo 'hdmi_group=2'>>/boot/config.txt
echo 'hdmi_mode=1'>>/boot/config.txt
echo 'hdmi_mode=87'>>/boot/config.txt
echo 'hdmi_timings=480 0 40 10 80 800 0 13 3 32 0 0 0 60 0 32000000 3'>>/boot/config.txt
echo 'dtoverlay=ads7846,cs=1,penirq=25,penirq_pull=2,speed=50000,keep_vref_on=0,swapxy=0,pmax=255,xohms=150,xmin=200,xmax=3900,ymin=200,ymax=3900'>>/boot/config.txt
echo 'display_rotate=3'>>/boot/config.txt
echo 'hdmi_drive=1'>>/boot/config.txt
echo 'hdmi_force_hotplug=1'>>/boot/config.txt

 touch $BASE_DIRECTORY/.4inch-lcd-touch-config

fi

if [ ! -f "$BASE_DIRECTORY/.usb-rule" ]; then

 touch /etc/udev/rules.d/52-usb.rules

sudo cat > "/etc/udev/rules.d/52-usb.rules" << EOF
#USB HUB PORT CONTROL
SUBSYSTEM=="usb", ATTR{idVendor}=="0424", MODE="0666" fi
#STM32 USB CONTROL
KERNEL=="hidraw*", ATTRS{busnum}=="1", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="a18b", 
MODE="0666"
#FT230x USB CONTROL
SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", MODE="0666"
EOF

 touch $BASE_DIRECTORY/.usb-rule

fi
