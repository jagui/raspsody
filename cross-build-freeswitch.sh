#!/bin/sh
set -x #echo on
set -e #stop on errors

#set host
host=arm-linux-gnueabihf

# Working directories
basedir=`pwd`
tools="tools"
freeswitch="freeswitch"
thirdparty="thirdparty"
prefix="/usr"

#Cross compiler toolchain
export AR=$basedir/$tools/arm-bcm2708/$host/bin/$host-ar
export CC=$basedir/$tools/arm-bcm2708/$host/bin/$host-gcc
export CXX=$basedir/$tools/arm-bcm2708/$host/bin/$host-c++
export LD=$basedir/$tools/arm-bcm2708/$host/bin/$host-gcc
export CROSS_COMPILE=$basedir/$tools/arm-bcm2708/$host/bin/$host-gcc
export LDFLAGS="-L$basedir/$tools/arm-bcm2708/$host/lib/gcc/$host/4.8.3  -L$basedir/$tools/arm-bcm2708/$host/$host/lib -ldl -lc"

# Get the cross compiling tools
if [ ! -d "$tools" ]; then
  echo "cloning cross compiler tools"
  echo "git clone git@github.com:raspberrypi/tools.git"
  git clone git@github.com:raspberrypi/tools.git
else
  echo "cross compiler tools already present, skip cloning"
fi

# Get additional headers
if [ ! -d "$thirdparty" ]; then
  echo "creating thirdparty folder"
  mkdir $thirdparty
fi

# Clone freeswitch master
if [ ! -d "$freeswitch" ]; then
  echo "cloning freeswitch master"
  echo "git clone https://freeswitch.org/stash/scm/fs/freeswitch.git"
  git clone https://freeswitch.org/stash/scm/fs/freeswitch.git
else
  echo "freeswitch master already present, skip cloning"
fi

# Get zlib-dev headers
zlibdev="zlib1g-dev_1.2.8.dfsg-5_armhf"
if [ ! -d "$thirdparty/$zlibdev" ]; then
  echo "downloading zlib-dev"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/z/zlib/$zlibdev.deb
  dpkg -x $zlibdev.deb $zlibdev
  rm $zlibdev.deb
  cd $basedir
else
  echo "zlib-dev already present, skip downloading"
fi

# Get zlib headers
zlib="zlib1g_1.2.8.dfsg-5_armhf"
if [ ! -d "$thirdparty/$zlib" ]; then
  echo "downloading zlib"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/z/zlib/$zlib.deb
  dpkg -x $zlib.deb $zlib
  rm $zlib.deb
  cd $zlib/lib/$host
  ln -sf libz.so.1 libz.so
  cd $basedir
else
  echo "zlib already present, skip downloading"
fi

# Get libjpeg dev
libjpegdev="libjpeg62-turbo-dev_1.5.1-2_armhf"
if [ ! -d "$thirdparty/$libjpegdev" ]; then
  echo "downloading libjpeg-dev"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/libj/libjpeg-turbo/$libjpegdev.deb
  dpkg -x $libjpegdev.deb $libjpegdev
  rm $libjpegdev.deb
  cd $basedir
else
  echo "libjpeg-dev already present, skip downloading"
fi

# Get libjpeg
libjpeg="libjpeg62-turbo_1.5.1-2_armhf"
if [ ! -d "$thirdparty/$libjpeg" ]; then
  echo "downloading libjpeg"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/libj/libjpeg-turbo/$libjpeg.deb
  dpkg -x $libjpeg.deb $libjpeg
  rm $libjpeg.deb
  cd $libjpeg/usr/lib/$host
  ln -sf libjpeg.so.62 libjpeg.so
  cd $basedir
else
  echo "libjpeg already present, skip downloading"
fi

# Get libsqlite3 dev
libsqlite3dev="libsqlite3-dev_3.16.2-5+deb9u1_armhf"
if [ ! -d "$thirdparty/$libsqlite3dev" ]; then
  echo "downloading libsqlite3-dev"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/s/sqlite3/$libsqlite3dev.deb
  dpkg -x $libsqlite3dev.deb $libsqlite3dev
  rm $libsqlite3dev.deb
  cd $basedir
else
  echo "libsqlite3-dev already present, skip downloading"
fi

# Get libcurl4 dev (openssl flavour)
libcurl4dev="libcurl4-openssl-dev_7.52.1-5+deb9u3_armhf"
if [ ! -d "$thirdparty/$libcurl4dev" ]; then
  echo "downloading libcurl4-dev"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/c/curl/$libcurl4dev.deb
  dpkg -x $libcurl4dev.deb $libcurl4dev
  rm $libcurl4dev.deb
  cd $basedir
else
  echo "libcurl4-dev already present, skip downloading"
fi

#Get libpcre3-dev
libpcre3dev="libpcre3-dev_8.39-3_armhf"
if [ ! -d "$thirdparty/$libpcre3dev" ]; then
  echo "downloading libpcre3-dev"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/p/pcre3/$libpcre3dev.deb
  dpkg -x $libpcre3dev.deb $libpcre3dev
  rm $libpcre3dev.deb
  cd $basedir
else
  echo "libpcre3-dev already present, skip downloading"
fi

#Get libspeex-dev
libspeexdev="libspeex-dev_1.2~rc1.2-1+b2_armhf"
if [ ! -d "$thirdparty/$libspeexdev" ]; then
  echo "downloading libspeex-dev"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/s/speex/$libspeexdev.deb
  dpkg -x $libspeexdev.deb $libspeexdev
  rm $libspeexdev.deb
  cd $basedir
else
  echo "libspeex-dev already present, skip downloading"
fi


#Get libspeexdsp-dev
libspeexdspdev="libspeexdsp-dev_1.2~rc1.2-1+b2_armhf"
if [ ! -d "$thirdparty/$libspeexdspdev" ]; then
  echo "downloading libspeexdsp-dev"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/s/speex/$libspeexdspdev.deb
  dpkg -x $libspeexdspdev.deb $libspeexdspdev
  rm $libspeexdspdev.deb
  cd $basedir
else
  echo "libspeexdsp-dev already present, skip downloading"
fi

# Configure and build freeswitch
cd $basedir/$freeswitch
export CFLAGS="-I$basedir/$thirdparty/$zlibdev/usr/include\
  -I$basedir/$thirdparty/$libjpegdev/usr/include\
  -I$basedir/$thirdparty/$libjpegdev/usr/include/$host\
  "
export LDFLAGS="$LDFLAGS -L$basedir/$thirdparty/$zlib/lib/$host\
  -L$basedir/$thirdparty/$libjpeg/usr/lib/$host\
  "
export CXXFLAGS="$CFLAGS"
export config_TARGET_CC="$CC";
export config_BUILD_CC="$HOSTCC";
export config_TARGET_CFLAGS="$CFLAGS";
export config_TARGET_LIBS="$LDFLAGS";
export CC_FOR_BUILD="$HOSTCC";
export CFLAGS_FOR_BUILD="$CFLAGS";
export ac_cv_file__dev_zero=no;
export apr_cv_tcp_nodelay_with_cork=yes;
export ac_cv_sizeof_ssize_t=4;
export ac_cv_file_dbd_apr_dbd_mysql_c=yes;
export ac_cv_path__libcurl_config=/path/curl-config;
export apr_cv_mutex_recursive=yes;
export ac_cv_func_pthread_rwlock_init=yes;
export apr_cv_type_rwlock_t=yes;
export PKG_CONFIG_PATH=$basedir/$thirdparty/$libsqlite3dev/usr/lib/$host/pkgconfig:$basedir/$thirdparty/$libcurl4dev/usr/lib/$host/pkgconfig:$basedir/$thirdparty/$libpcre3dev/usr/lib/$host/pkgconfig:$basedir/$thirdparty/$libspeexdev/usr/lib/$host/pkgconfig:$basedir/$thirdparty/$libspeexdspdev/usr/lib/$host/pkgconfig:$PKG_CONFIG_PATH
       #./configure \
       #--target=$(GNU_TARGET_NAME) \
       #--host=$(GNU_TARGET_NAME) \
       #--build=$(GNU_HOST_NAME) \
       #--with-libcurl=/path/install \
       #--with-devrandom=/dev/urandom \
       #--with-modinstdir=/mod \

./bootstrap.sh -j
./configure -C --host=$host --target=$host --prefix=$prefix
make -j3
