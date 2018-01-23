#!/bin/sh
set -x #echo on
set -e #stop on errors

# Working directories
basedir=`pwd`
tools="tools"
pjproject="trunk"
includes="includes"
prefix="/usr/local"
install="install"

#Cross compiler toolchain
export AR=$basedir/$tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/arm-linux-gnueabihf-ar
export CC=$basedir/$tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/arm-linux-gnueabihf-gcc
export CXX=$basedir/$tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/arm-linux-gnueabihf-c++
export LD=$basedir/$tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/arm-linux-gnueabihf-gcc
export CROSS_COMPILE=$basedir/$tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/arm-linux-gnueabihf-gcc
export LDFLAGS="-L$basedir/$tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/lib/gcc/arm-linux-gnueabihf/4.8.3  -L$basedir/$tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/arm-linux-gnueabihf/lib -ldl -lc"

# Get the cross compiling tools
if [ ! -d "$tools" ]; then
  echo "cloning cross compiler tools"
  echo "git clone git@github.com:raspberrypi/tools.git"
  git clone git@github.com:raspberrypi/tools.git
else
  echo "cross compiler tools already present, skip cloning"
fi

# Get the latest stable pjproject
if [ ! -d "$pjproject" ]; then
  echo "checking out pjproject trunk"
  echo "svn checkout http://svn.pjsip.org/repos/pjproject/trunk/"
  svn checkout http://svn.pjsip.org/repos/pjproject/trunk/
else
  echo "pjproject trunk already present, skip checking out"
fi

# Configure and build pjproject
cd $basedir/$pjproject
./aconfigure --host=arm-linux-gnueabihf --disable-video --disable-libwebrtc --prefix=$prefix
make dep
export CFLAGS="$CFLAGS-DPJMEDIA_AUDIO_DEV_HAS_ALSA=0"
make
make DESTDIR=$basedir/$install install
