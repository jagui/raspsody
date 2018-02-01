#!/bin/sh
set -x #echo on
set -e #stop on errors

#install freeswitch dependencies
apt install zlib1g-dev:armhf\
  zlib1g:armhf\
  libjpeg-dev\
  libjpeg62-turbo:armhf\
  libsqlite3-dev:armhf\
  libsqlite3-0:armhf\
  libcurl4-openssl-dev:armhf\
  libcurl3:armhf\
  libpcre3-dev:armhf\
  libpcre3:armhf\
  libspeex-dev:armhf\
  libspeex1:armhf\
  libspeexdsp-dev:armhf\
  libspeexdsp1:armhf\
  libldns-dev:armhf\
  libldns2:armhf\
  libedit-dev:armhf\
  libedit2:armhf\
  libssl-dev:armhf\
  libssl1.0.2:armhf\
  libtiff5-dev:armhf\
  libtiff5:armhf\
  liblzma5:armhf

#set host
host=arm-linux-gnueabihf

# Working directories
cd /tmp/freeswitch #TODO: pass this path
basedir=`pwd`
tools="tools" #TODO: pass this path
freeswitch="freeswitch" #TODO: pass this path
prefix="/usr"

#Cross compiler toolchain
export AS=$host-as
export AR=$host-ar
export CC=$host-gcc
export CXX=$host-g++
export LD=$host-gcc
export
export CROSS_COMPILE=$host-gcc
#export LDFLAGS="-L$basedir/$tools/arm-bcm2708/$host/lib/gcc/$host/4.9.3 -L$basedir/$tools/arm-bcm2708/$host/$host/lib"

# Configure and build freeswitch
export LIBS="-ljbig -llzma -ltiff -lssl -lcrypto -lldns -lspeexdsp -lspeex -lpcre -ljpeg -lz -ldl -lc"
export CFLAGS="-I/usr/include -I/usr/include/$host $CFLAGS"
export LDFLAGS="-L/usr/lib/$host -L/lib/$host $LDFLAGS"
export PKG_CONFIG_PATH="/usr/lib/$host/pkgconfig"
export PKG_CONFIG_LIBDIR="/usr/lib/$host"
export CXXFLAGS="$CFLAGS"
export config_TARGET_CC="$CC"
export config_BUILD_CC="/usr/bin/gcc"
export config_TARGET_CFLAGS="$CFLAGS"
export config_TARGET_LIBS="$LDFLAGS"
export CC_FOR_BUILD="$config_BUILD_CC"
export CFLAGS_FOR_BUILD=" "
export openssl_CFLAGS="$CFLAGS"
export openssl_LIBS="$LDFLAGS"
export ac_cv_file__dev_zero=no
export apr_cv_tcp_nodelay_with_cork=yes
export ac_cv_sizeof_ssize_t=4
export ac_cv_file_dbd_apr_dbd_mysql_c=yes
export apr_cv_mutex_recursive=yes
export ac_cv_func_pthread_rwlock_init=yes
export apr_cv_type_rwlock_t=yes

cd $basedir/$freeswitch
./bootstrap.sh
./configure -C --host=$host --target=$host --prefix=$prefix  --disable-libvpx --disable-cpp
make -j1 V=1
