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
export AS=$basedir/$tools/arm-bcm2708/$host/bin/$host-as
export AR=$basedir/$tools/arm-bcm2708/$host/bin/$host-ar
export CC=$basedir/$tools/arm-bcm2708/$host/bin/$host-gcc
export CXX=$basedir/$tools/arm-bcm2708/$host/bin/$host-c++
export LD=$basedir/$tools/arm-bcm2708/$host/bin/$host-gcc
export CROSS_COMPILE=$basedir/$tools/arm-bcm2708/$host/bin/$host-gcc
export LDFLAGS="-L$basedir/$tools/arm-bcm2708/$host/lib/gcc/$host/4.9.3  -L$basedir/$tools/arm-bcm2708/$host/$host/lib -ldl -lc"

# Get the cross compiling tools
if [ ! -e "$tools" ]; then
  echo "cloning cross compiler tools"
  echo "git clone git@github.com:raspberrypi/tools.git"
  git clone git@github.com:raspberrypi/tools.git
else
  echo "cross compiler tools already present, skip cloning"
fi

# Get additional headers
if [ ! -e "$thirdparty" ]; then
  echo "creating thirdparty folder"
  mkdir $thirdparty
fi

# Clone freeswitch master
if [ ! -e "$freeswitch" ]; then
  echo "cloning freeswitch master"
  echo "git clone https://freeswitch.org/stash/scm/fs/freeswitch.git"
  git clone https://freeswitch.org/stash/scm/fs/freeswitch.git
else
  echo "freeswitch master already present, skip cloning"
fi

# Get zlib-dev headers
zlibdev="zlib1g-dev_1.2.8.dfsg-5_armhf.deb"
if [ ! -e "$thirdparty/$zlibdev" ]; then
  echo "downloading zlib-dev"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/z/zlib/$zlibdev
  dpkg -x $zlibdev ../.
  cd $basedir
else
  echo "zlib-dev already present, skip downloading"
fi
export LIBS="-lz $LIBS"

# Get libjpeg dev
libjpegdev="libjpeg62-turbo-dev_1.5.1-2_armhf.deb"
if [ ! -e "$thirdparty/$libjpegdev" ]; then
  echo "downloading libjpeg-dev"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/libj/libjpeg-turbo/$libjpegdev
  dpkg -x $libjpegdev ../.
  cd $basedir
else
  echo "libjpeg-dev already present, skip downloading"
fi
export LIBS="-ljpeg $LIBS"

# Get libsqlite3 dev
libsqlite3dev="libsqlite3-dev_3.16.2-5+deb9u1_armhf.deb"
if [ ! -e "$thirdparty/$libsqlite3dev" ]; then
  echo "downloading libsqlite3-dev"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/s/sqlite3/$libsqlite3dev
  dpkg -x $libsqlite3dev ../.
  cd $basedir
else
  echo "libsqlite3-dev already present, skip downloading"
fi
export LIBS="-lsqlite3 $LIBS"

# Get libcurl4 dev (openssl flavour)
libcurl4dev="libcurl4-openssl-dev_7.52.1-5+deb9u3_armhf.deb"
if [ ! -e "$thirdparty/$libcurl4dev" ]; then
  echo "downloading libcurl4-dev"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/c/curl/$libcurl4dev
  dpkg -x $libcurl4dev ../.
  cd $basedir
else
  echo "libcurl4-dev already present, skip downloading"
fi
export LIBS="-lcurl $LIBS"

#Get libpcre3-dev
libpcre3dev="libpcre3-dev_8.39-3_armhf.deb"
if [ ! -e "$thirdparty/$libpcre3dev" ]; then
  echo "downloading libpcre3-dev"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/p/pcre3/$libpcre3dev
  dpkg -x $libpcre3dev ../.
  cd $basedir
else
  echo "libpcre3-dev already present, skip downloading"
fi
export LIBS="-lpcre $LIBS"

#Get libspeex-dev
libspeexdev="libspeex-dev_1.2~rc1.2-1+b2_armhf.deb"
if [ ! -e "$thirdparty/$libspeexdev" ]; then
  echo "downloading libspeex-dev"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/s/speex/$libspeexdev
  dpkg -x $libspeexdev ../.
  cd $basedir
else
  echo "libspeex-dev already present, skip downloading"
fi
export LIBS="-lspeex $LIBS"

#Get libspeexdsp-dev
libspeexdspdev="libspeexdsp-dev_1.2~rc1.2-1+b2_armhf.deb"
if [ ! -e "$thirdparty/$libspeexdspdev" ]; then
  echo "downloading libspeexdsp-dev"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/s/speex/$libspeexdspdev
  dpkg -x $libspeexdspdev ../.
  cd $basedir
else
  echo "libspeexdsp-dev already present, skip downloading"
fi
export LIBS="-lspeexdsp $LIBS"

#Get libldns-dev
libldnsdev="libldns-dev_1.7.0-1_armhf.deb"
if [ ! -e "$thirdparty/$libldnsdev" ]; then
  echo "downloading libldns-dev"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/l/ldns/$libldnsdev
  dpkg -x $libldnsdev ../.
  cd $basedir
else
  echo "libldns-dev already present, skip downloading"
fi
export LIBS="-lldns $LIBS"

#Get libedit-dev
libeditdev="libedit-dev_3.1-20160903-3_armhf.deb"
if [ ! -e "$thirdparty/$libeditdev" ]; then
  echo "downloading libedit-dev"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/libe/libedit/$libeditdev
  dpkg -x $libeditdev ../.
  cd $basedir
else
  echo "libedit-dev already present, skip downloading"
fi
export LIBS="-ledit $LIBS"

#Get openssl-dev
openssldev="libssl-dev_1.1.0f-3+deb9u1_armhf.deb"
if [ ! -e "$thirdparty/$openssldev" ]; then
  echo "downloading openssl-dev"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/o/openssl/$openssldev
  dpkg -x $openssldev ../.
  cd $basedir
else
  echo "openssl-dev already present, skip downloading"
fi

#Get openssl
openssl="libssl1.1_1.1.0f-3+deb9u1_armhf.deb"
if [ ! -e "$thirdparty/$openssl" ]; then
  echo "downloading openssl"
  cd $basedir/$thirdparty
  wget http://security.debian.org/debian-security/pool/updates/main/o/openssl/$openssl
  dpkg -x $openssl ../.
  cd $basedir
else
  echo "openssl already present, skip downloading"
fi
export LIBS="-lssl -lcrypto $LIBS"
#Get libtiff-dev

libtiffdev="libtiff5-dev_4.0.8-2+deb9u2_armhf.deb"
if [ ! -e "$thirdparty/$libtiffdev" ]; then
  echo "downloading libtiff-dev"
  cd $basedir/$thirdparty
  wget http://security.debian.org/debian-security/pool/updates/main/t/tiff/$libtiffdev
  dpkg -x $libtiffdev ../.
  cd $basedir
else
  echo "libtiff-dev already present, skip downloading"
fi
export LIBS="-ltiff $LIBS"

#Get libzma-dev
liblzmadev="liblzma-dev_5.2.2-1.2+b1_armhf.deb"
if [ ! -e "$thirdparty/$liblzmadev" ]; then
  echo "downloading liblzmadev"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/x/xz-utils/$liblzmadev
  dpkg -x $liblzmadev ../.
  cd $basedirs
else
  echo "liblzmadev already present, skip downloading"
fi
export LIBS="-llzma $LIBS"

# Get libjbigdev
libjbigdev="libjbig-dev_2.1-3.1+b2_armhf.deb"
if [ ! -e "$thirdparty/$libjbigdev" ]; then
  echo "downloading libjbigdev"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/j/jbigkit/$libjbigdev
  dpkg -x $libjbigdev ../.
  cd $basedirs
else
  echo "libjbigdev already present, skip downloading"
fi
export LIBS="-ljbig $LIBS"

# Configure and build freeswitch
cd $basedir/$freeswitch

export CFLAGS="-I$basedir/usr/include -I$basedir/usr/include/$host $CFLAGS"
export LDFLAGS="-L$basedir/usr/lib/$host $LDFLAGS"
export PKG_CONFIG_PATH="$basedir/usr/lib/$host/pkgconfig"
export PKG_CONFIG_LIBDIR="$basedir/usr/lib/$host"
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

./bootstrap.sh
./configure -C --host=$host --target=$host --prefix=$prefix  --disable-libvpx --disable-cpp
make
