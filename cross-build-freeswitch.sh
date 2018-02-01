#!/bin/sh
set -x #echo on
set -e #stop on errors

# directories and files
export chrootdir="chroot"
export builddir="/tmp/freeswitch"
export configscript="chrooted-configure-chroot.sh"
export buildscript="chrooted-cross-build-freeswitch.sh"
export tools="tools"
export freeswitch="freeswitch"

# Call script for creating chroot
./create-chroot.sh

# Create tmp folder in chroot
if [ ! -d "$chrootdir$builddir" ]; then
  mkdir $chrootdir$builddir
fi

# Call script for configuring chroot
cp -f $configscript $chrootdir$builddir/.
chmod +x $chrootdir$builddir/$configscript

export  LC_ALL=C
sudo chroot $chrootdir .$builddir/$configscript

# Clone freeswitch master
if [ ! -e "$freeswitch" ]; then
  echo "cloning freeswitch master"
  echo "git clone https://freeswitch.org/stash/scm/fs/freeswitch.git"
  git clone https://freeswitch.org/stash/scm/fs/freeswitch.git
else
  echo "freeswitch master already present, skip cloning"
fi
cp -rf $freeswitch $chrootdir$builddir/$freeswitch

# Run build script in chroot
cp -f $buildscript $chrootdir$builddir/.
chmod +x $chrootdir$builddir/$buildscript
sudo chroot $chrootdir .$builddir/$buildscript
