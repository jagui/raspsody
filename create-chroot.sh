#!/bin/sh
set -x #echo on
set -e #stop on errors

# Create chroot
if [ ! -d "$chrootdir" ]; then
  mkdir $chrootdir
  sudo debootstrap stretch $chrootdir http://httpredir.debian.org/debian
fi
