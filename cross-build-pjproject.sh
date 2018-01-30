#!/bin/sh
set -x #echo on
set -e #stop on errors

#set host
host=arm-linux-gnueabihf

# Working directories
basedir=`pwd`
tools="tools"
pjproject="pjproject"
thirdparty="thirdparty"
prefix="/usr"

#Cross compiler toolchain
export AR=$basedir/$tools/arm-bcm2708/$host/bin/$host-ar
export CC=$basedir/$tools/arm-bcm2708/$host/bin/$host-gcc
export CXX=$basedir/$tools/arm-bcm2708/$host/bin/$host-c++
export LD=$basedir/$tools/arm-bcm2708/$host/bin/$host-gcc
export CROSS_COMPILE=$basedir/$tools/arm-bcm2708/$host/bin/$host-gcc
export LDFLAGS="-L$basedir/$tools/arm-bcm2708/$host/lib/gcc/$host/4.9.3 -L$basedir/$tools/arm-bcm2708/$host/$host/lib -ldl -lc"

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
  echo "svn checkout http://svn.pjsip.org/repos/pjproject/trunk/ $pjproject"
  svn checkout http://svn.pjsip.org/repos/pjproject/trunk/ $pjproject
else
  echo "pjproject trunk already present, skip checking out"
fi

# Get additional headers
if [ ! -d "$thirdparty" ]; then
  echo "creating thirdparty folder"
  mkdir $thirdparty
fi

# Get libasound2
libasound2="libasound2_1.1.3-5_armhf"
if [ ! -d "$thirdparty/$libasound2" ]; then
  echo "downloading libasound2"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/a/alsa-lib/$libasound2.deb
  dpkg -x $libasound2.deb $libasound2
  rm $libasound2.deb
  # So that pjproject can find -lasound
  cd $libasound2/usr/lib/$host
  ln -sf libasound.so.2.0.0 libasound.so
  cd $basedir
else
  echo "libasound2 already present, skip downloading"
fi

# Get libasound2-dev headers (required by ALSA)
libasound2dev="libasound2-dev_1.1.3-5_armhf"
if [ ! -d "$thirdparty/$libasound2dev" ]; then
  echo "downloading libasound2-dev"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/a/alsa-lib/$libasound2dev.deb
  dpkg -x $libasound2dev.deb $libasound2dev
  rm $libasound2dev.deb
  cd $basedir
else
  echo "libasound2-dev already present, skip downloading"
fi

# Configure and build pjproject
cd $basedir/$pjproject
export CFLAGS="-I$basedir/$thirdparty/$libasound2dev/usr/include"
export LDFLAGS="$LDFLAGS -L$basedir/$thirdparty/$libasound2/usr/lib/$host"
./aconfigure --host=$host --disable-video --disable-libwebrtc --prefix=$prefix
make dep
make
