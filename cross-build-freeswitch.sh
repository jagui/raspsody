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
export CFLAGS="-I$basedir/$thirdparty/$zlibdev/usr/include $CFLAGS"

# Get zlib
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
export LDFLAGS="-L$basedir/$thirdparty/$zlib/lib/$host $LDFLAGS"
export LIBS="-lz $LIBS"

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
export CFLAGS="-I$basedir/$thirdparty/$libjpegdev/usr/include $CFLAGS"
export CFLAGS="-I$basedir/$thirdparty/$libjpegdev/usr/include/$host $CFLAGS"

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
export LDFLAGS="-L$basedir/$thirdparty/$libjpeg/usr/lib/$host $LDFLAGS"
export LIBS="-ljpeg $LIBS"

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
export CFLAGS="-I$basedir/$thirdparty/$libsqlite3dev/usr/include $CFLAGS"
export PKG_CONFIG_PATH=$basedir/$thirdparty/$libsqlite3dev/usr/lib/$host/pkgconfig

# Get sqlite3
libsqlite3="libsqlite3-0_3.16.2-5+deb9u1_armhf"
if [ ! -d "$thirdparty/$libsqlite3" ]; then
  echo "downloading libsqlite3"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/s/sqlite3/$libsqlite3.deb
  dpkg -x $libsqlite3.deb $libsqlite3
  rm $libsqlite3.deb
  cd $libsqlite3/usr/lib/$host
  ln -sf libsqlite3.so.0 libsqlite3.so
  cd $basedir
else
  echo "sqlite3 already present, skip downloading"
fi
export LDFLAGS="-L$basedir/$thirdparty/$libsqlite3/usr/lib/$host $LDFLAGS"
export LIBS="-lsqlite3 $LIBS"

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
export CFLAGS="-I$basedir/$thirdparty/$libcurl4dev/usr/include/$host $CFLAGS"
export PKG_CONFIG_PATH=$basedir/$thirdparty/$libcurl4dev/usr/lib/$host/pkgconfig:$PKG_CONFIG_PATH

# Get libcurl
libcurl3="libcurl3_7.52.1-5+deb9u4_armhf"
if [ ! -d "$thirdparty/$libcurl3" ]; then
  echo "downloading libcurl3"
  cd $basedir/$thirdparty
  wget http://security.debian.org/debian-security/pool/updates/main/c/curl/$libcurl3.deb
  dpkg -x $libcurl3.deb $libcurl3
  rm $libcurl3.deb
  cd $libcurl3/usr/lib/$host
  ln -sf libcurl.so.4 libcurl.so
  cd $basedir
else
  echo "libcurl3 already present, skip downloading"
fi
export LDFLAGS="-L$basedir/$thirdparty/$libcurl3/usr/lib/$host $LDFLAGS"
export LIBS="-lcurl $LIBS"

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
export CFLAGS="-I$basedir/$thirdparty/$libpcre3dev/usr/include $CFLAGS"
export PKG_CONFIG_PATH=$basedir/$thirdparty/$libpcre3dev/usr/lib/$host/pkgconfig:$PKG_CONFIG_PATH

# Get libpcre3
libpcre3="libpcre3_8.39-3_armhf"
if [ ! -d "$thirdparty/$libpcre3" ]; then
  echo "downloading libpcre3"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/p/pcre3/$libpcre3.deb
  dpkg -x $libpcre3.deb $libpcre3
  rm $libpcre3.deb
  cd $libpcre3/lib/$host
  ln -sf libpcre.so.3 libpcre.so
  cd $basedir
else
  echo "libpcre3 already present, skip downloading"
fi
export LDFLAGS="-L$basedir/$thirdparty/$libpcre3/lib/$host $LDFLAGS"
export LIBS="-lpcre $LIBS"

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
export CFLAGS="-I$basedir/$thirdparty/$libspeexdev/usr/include/ $CFLAGS"
export PKG_CONFIG_PATH=$basedir/$thirdparty/$libspeexdev/usr/lib/$host/pkgconfig:$PKG_CONFIG_PATH

# Get libspeex
libspeex="libspeex1_1.2~rc1.2-1+b2_armhf"
if [ ! -d "$thirdparty/$libspeex" ]; then
  echo "downloading libspeex"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/s/speex/$libspeex.deb
  dpkg -x $libspeex.deb $libspeex
  rm $libspeex.deb
  cd $libspeex/usr/lib/$host
  ln -sf libspeex.so.1 libspeex.so
  cd $basedir
else
  echo "libspeex already present, skip downloading"
fi
export LDFLAGS="-L$basedir/$thirdparty/$libspeex/usr/lib/$host $LDFLAGS"
export LIBS="-lspeex $LIBS"

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
export CFLAGS="-I$basedir/$thirdparty/$libspeexdspdev/usr/include/ $CFLAGS"
export PKG_CONFIG_PATH=$basedir/$thirdparty/$libspeexdspdev/usr/lib/$host/pkgconfig:$PKG_CONFIG_PATH

# Get libspeexdsp
libspeexdsp="libspeexdsp1_1.2~rc1.2-1+b2_armhf"
if [ ! -d "$thirdparty/$libspeexdsp" ]; then
  echo "downloading libspeexdsp"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/s/speex/$libspeexdsp.deb
  dpkg -x $libspeexdsp.deb $libspeexdsp
  rm $libspeexdsp.deb
  cd $libspeexdsp/usr/lib/$host
  ln -sf libspeexdsp.so.1 libspeexdsp.so
  cd $basedir
else
  echo "libspeexdsp already present, skip downloading"
fi
export LDFLAGS="-L$basedir/$thirdparty/$libspeexdsp/usr/lib/$host $LDFLAGS"
export LIBS="-lspeexdsp $LIBS"

#Get libldns-dev
libldnsdev="libldns-dev_1.7.0-1_armhf"
if [ ! -d "$thirdparty/$libldnsdev" ]; then
  echo "downloading libldns-dev"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/l/ldns/$libldnsdev.deb
  dpkg -x $libldnsdev.deb $libldnsdev
  rm $libldnsdev.deb
  cd $basedir
else
  echo "libldns-dev already present, skip downloading"
fi
export CFLAGS="-I$basedir/$thirdparty/$libldnsdev/usr/include/ $CFLAGS"
export PKG_CONFIG_PATH=$basedir/$thirdparty/$libldnsdev/usr/lib/$host/pkgconfig:$PKG_CONFIG_PATH

# Get libldns
libldns="libldns2_1.7.0-1_armhf"
if [ ! -d "$thirdparty/$libldns" ]; then
  echo "downloading libldns"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/l/ldns/$libldns.deb
  dpkg -x $libldns.deb $libldns
  rm $libldns.deb
  cd $libldns/usr/lib/$host
  ln -sf libldns.so.2 libldns.so
  cd $basedir
else
  echo "libldns already present, skip downloading"
fi
export LDFLAGS="-L$basedir/$thirdparty/$libldns/usr/lib/$host $LDFLAGS"
export LIBS="-lldns $LIBS"

#Get libedit-dev
libeditdev="libedit-dev_3.1-20160903-3_armhf"
if [ ! -d "$thirdparty/$libeditdev" ]; then
  echo "downloading libedit-dev"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/libe/libedit/$libeditdev.deb
  dpkg -x $libeditdev.deb $libeditdev
  rm $libeditdev.deb
  cd $basedir
else
  echo "libedit-dev already present, skip downloading"
fi
export CFLAGS="-I$basedir/$thirdparty/$libeditdev/usr/include/ $CFLAGS"
export PKG_CONFIG_PATH=$basedir/$thirdparty/$libeditdev/usr/lib/$host/pkgconfig:$PKG_CONFIG_PATH

# Get libedit
libedit="libedit2_3.1-20160903-3_armhf"
if [ ! -d "$thirdparty/$libedit" ]; then
  echo "downloading libedit"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/libe/libedit/$libedit.deb
  dpkg -x $libedit.deb $libedit
  rm $libedit.deb
  cd $libedit/usr/lib/$host
  ln -sf libedit.so.2 libedit.so
  cd $basedir
else
  echo "libedit already present, skip downloading"
fi
export LDFLAGS="-L$basedir/$thirdparty/$libedit/usr/lib/$host $LDFLAGS"
export LIBS="-ledit $LIBS"

#Get openssl-dev
openssldev="libssl-dev_1.1.0f-3+deb9u1_armhf"
if [ ! -d "$thirdparty/$openssldev" ]; then
  echo "downloading openssl-dev"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/o/openssl/$openssldev.deb
  dpkg -x $openssldev.deb $openssldev
  rm $openssldev.deb
  cd $basedir
else
  echo "openssl-dev already present, skip downloading"
fi
export CFLAGS="-I$basedir/$thirdparty/$openssldev/usr/include/$host $CFLAGS"
export CFLAGS="-I$basedir/$thirdparty/$openssldev/usr/include $CFLAGS"
export openssl_CFLAGS="-I$basedir/$thirdparty/$openssldev/usr/include"
export openssl_CFLAGS="-I$basedir/$thirdparty/$openssldev/usr/include/$host $openssl_CFLAGS"
export PKG_CONFIG_PATH=$basedir/$thirdparty/$openssldev/usr/lib/$host/pkgconfig:$PKG_CONFIG_PATH

#Get openssl
openssl="libssl1.1_1.1.0f-3+deb9u1_armhf"
if [ ! -d "$thirdparty/$openssl" ]; then
  echo "downloading openssl"
  cd $basedir/$thirdparty
  wget http://security.debian.org/debian-security/pool/updates/main/o/openssl/$openssl.deb
  dpkg -x $openssl.deb $openssl
  rm $openssl.deb
  cd $openssl/usr/lib/$host
  ln -sf libcrypto.so.1.1 libcrypto.so
  ln -sf libssl.so.1.1 libssl.so
  cd $basedir
else
  echo "openssl already present, skip downloading"
fi
export LDFLAGS="-L$basedir/$thirdparty/$openssl/usr/lib/$host $LDFLAGS"
export openssl_LIBS="-L$basedir/$thirdparty/$openssl/usr/lib/$host/"
export LIBS="-lssl -lcrypto $LIBS"

#Get libtiff-dev
libtiffdev="libtiff5-dev_4.0.8-2+deb9u2_armhf"
if [ ! -d "$thirdparty/$libtiffdev" ]; then
  echo "downloading libtiff-dev"
  cd $basedir/$thirdparty
  wget http://security.debian.org/debian-security/pool/updates/main/t/tiff/$libtiffdev.deb
  dpkg -x $libtiffdev.deb $libtiffdev
  rm $libtiffdev.deb
  cd $basedir
else
  echo "libtiff-dev already present, skip downloading"
fi
export CFLAGS="-I$basedir/$thirdparty/$libtiffdev/usr/include/$host $CFLAGS"

#Get libtiff
libtiff="libtiff5_4.0.3-12.3+deb8u5_armhf"
if [ ! -d "$thirdparty/$libtiff" ]; then
  echo "downloading libtiff"
  cd $basedir/$thirdparty
  wget http://security.debian.org/debian-security/pool/updates/main/t/tiff/$libtiff.deb
  dpkg -x $libtiff.deb $libtiff
  rm $libtiff.deb
  cd $libtiff/usr/lib/$host
  ln -sf libtiff.so.5 libtiff.so
  cd $basedir
else
  echo "libtiff already present, skip downloading"
fi
export LDFLAGS="-L$basedir/$thirdparty/$libtiff/usr/lib/$host $LDFLAGS"
export LIBS="-ltiff $LIBS"

#Get libtifxx
# libtifxx="libtiffxx5_4.0.8-2+deb9u2_armhf"
# if [ ! -d "$thirdparty/$libtifxx" ]; then
#   echo "downloading libtifxx"
#   cd $basedir/$thirdparty
#   wget http://security.debian.org/debian-security/pool/updates/main/t/tiff/$libtifxx.deb
#   dpkg -x $libtifxx.deb $libtifxx
#   rm $libtifxx.deb
#   cd $libtifxx/usr/lib/$host
#   ln -sf libtiffxx.so.5 libtiffxx.so
#   cd $basedir
# else
#   echo "libtifxx already present, skip downloading"
# fi
# export LDFLAGS="-L$basedir/$thirdparty/$libtifxx/usr/lib/$host $LDFLAGS"
# export LIBS="-ltiffxx $LIBS"

#Get libzma
liblzma="liblzma5_5.2.2-1.2+b1_armhf"
if [ ! -d "$thirdparty/$liblzma" ]; then
  echo "downloading liblzma"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/x/xz-utils/$liblzma.deb
  dpkg -x $liblzma.deb $liblzma
  rm $liblzma.deb
  cd $liblzma/lib/$host
  ln -sf liblzma.so.5 liblzma.so
  cd $basedirs
else
  echo "liblzma already present, skip downloading"
fi
export LDFLAGS="-L$basedir/$thirdparty/$liblzma/lib/$host $LDFLAGS"
export LIBS="-llzma $LIBS"

 # Get libjbig
libjbig="libjbig0_2.1-3.1+b2_armhf"
if [ ! -d "$thirdparty/$libjbig" ]; then
  echo "downloading libjbig"
  cd $basedir/$thirdparty
  wget http://http.us.debian.org/debian/pool/main/j/jbigkit/$libjbig.deb
  dpkg -x $libjbig.deb $libjbig
  rm $libjbig.deb
  cd $libjbig/usr/lib/$host
  ln -sf libjbig.so.0 libjbig.so
  cd $basedirs
else
  echo "libjbig already present, skip downloading"
fi
export LDFLAGS="-L$basedir/$thirdparty/$libjbig/usr/lib/$host $LDFLAGS"
export LIBS="-ljbig $LIBS"

# Get libncurses
libncurses="libncurses5_6.0+20161126-1+deb9u1_armhf"
if [ ! -d "$thirdparty/$libncurses" ]; then
 echo "downloading libncurses"
 cd $basedir/$thirdparty
 wget http://http.us.debian.org/debian/pool/main/n/ncurses/$libncurses.deb
 dpkg -x $libncurses.deb $libncurses
 rm $libncurses.deb
 cd $libncurses/lib/$host
 ln -sf libncurses.so.5 libncurses.so
 cd $basedirs
else
 echo "libncurses already present, skip downloading"
fi
export LDFLAGS="-L$basedir/$thirdparty/$libncurses/lib/$host $LDFLAGS"
export LIBS="-lncurses $LIBS"

# Get libtinfo
libtinfo="libtinfo5_6.0+20161126-1+deb9u1_armhf"
if [ ! -d "$thirdparty/$libtinfo" ]; then
 echo "downloading libtinfo"
 cd $basedir/$thirdparty
 wget http://http.us.debian.org/debian/pool/main/n/ncurses/$libtinfo.deb
 dpkg -x $libtinfo.deb $libtinfo
 rm $libtinfo.deb
 cd $libtinfo/lib/$host
 ln -sf libtinfo.so.5 libtinfo.so
 cd $basedirs
else
 echo "libtinfo already present, skip downloading"
fi
export LDFLAGS="-L$basedir/$thirdparty/$libtinfo/lib/$host $LDFLAGS"
export LIBS="-ltinfo $LIBS"

# Get libbsd
libbsd="libbsd0_0.8.3-1_armhf"
if [ ! -d "$thirdparty/$libbsd" ]; then
 echo "downloading libbsd"
 cd $basedir/$thirdparty
 wget http://http.us.debian.org/debian/pool/main/libb/libbsd/$libbsd.deb
 dpkg -x $libbsd.deb $libbsd
 rm $libbsd.deb
 cd $libbsd/lib/$host
 ln -sf libbsd.so.0 libbsd.so
 cd $basedirs
else
 echo "libbsd already present, skip downloading"
fi
export LDFLAGS="-L$basedir/$thirdparty/$libbsd/lib/$host $LDFLAGS"
export LIBS="-lbsd $LIBS"

# Configure and build freeswitch
cd $basedir/$freeswitch
export CXXFLAGS="$CFLAGS"
export config_TARGET_CC="$CC";
export config_BUILD_CC="/usr/bin/gcc";
export config_TARGET_CFLAGS="$CFLAGS";
export config_TARGET_LIBS="$LDFLAGS";
export CC_FOR_BUILD="$config_BUILD_CC";
export CFLAGS_FOR_BUILD="$CFLAGS";
export ac_cv_file__dev_zero=no;
export apr_cv_tcp_nodelay_with_cork=yes;
export ac_cv_sizeof_ssize_t=4;
export ac_cv_file_dbd_apr_dbd_mysql_c=yes;
export apr_cv_mutex_recursive=yes;
export ac_cv_func_pthread_rwlock_init=yes;
export apr_cv_type_rwlock_t=yes;

./bootstrap.sh
./configure -C --host=$host --target=$host --prefix=$prefix --quiet --disable-libvpx --disable-cpp
make
