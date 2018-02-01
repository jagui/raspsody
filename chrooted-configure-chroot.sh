#!/bin/sh
set -x #echo on
set -e #stop on errors

#configure apt and dpkg for installing armhf packages
dpkg --add-architecture armhf
echo 'deb [arch=amd64,armhf] http://httpredir.debian.org/debian stretch main' > /etc/apt/sources.list
apt update

#install build environment
apt install gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf locales libc-dev-armhf-cross autoconf automake libtool libtool-bin make pkg-config
