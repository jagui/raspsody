#!/bin/sh
set -x #echo on
set -e #stop on errors

# Working directories
tools="tools"
pjproject="trunk"
includes="includes"
basedir=`pwd`

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

# Get additional headers
if [ ! -d "$includes" ]; then
  echo "creating includes folder"
  mkdir $includes
fi

# Get python headers (required by ALSA)
python="libpython2.7-dev_2.7.9-2+deb8u1_armhf"
if [ ! -d "$includes/$python" ]; then
  echo "downloading Python headers"
  cd $basedir/$includes
  wget http://http.us.debian.org/debian/pool/main/p/python2.7/$python.deb
  dpkg -x $python.deb $python
  rm $python.deb
  cd $basedir
else
  echo "python headers already present, skip downloading"
fi

# Get ALSA lib
alsalib="alsa-lib-1.1.5"
if [ ! -d "$includes/$alsalib" ]; then
  echo "downloading ALSA lib"
  cd $basedir/$includes
  wget ftp://ftp.alsa-project.org/pub/lib/$alsalib.tar.bz2
  tar xvf $alsalib.tar.bz2
  rm $alsalib.tar.bz2
  cd $basedir
else
  echo "ALSA lib already present, skip downloading"
fi

# Build ALSA
cd $basedir/$includes/$alsalib
export CFLAGS="-I$basedir/$includes/$python/usr/include"
./configure --host=arm-linux-gnueabihf --prefix=$basedir/$includes/$alsalib/output
make
make install

# Configure and build pjproject
cd $basedir/$pjproject
export CFLAGS="-I$basedir/$includes/$alsalib/output/include"
export LDFLAGS="$LDFLAGS -L$basedir/$includes/$alsalib/output/lib"
./aconfigure --host=arm-linux-gnueabihf --disable-video --disable-libwebrtc --prefix=$basedir/$pjproject/output
make dep
make
make install
