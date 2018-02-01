# Raspsody

## Cross Compiling pjproject

Use the [script](./cross-build-pjproject.sh)!

Summary of what the script does:
* Uses the arm-linux-gnueabihf triplet
* Defines CC, CXX, etc for autoconf
* Gets the prebuilt cross build tools from the raspberrypi tools repo (thanks pals!)
* svn checkout of pjproject's trunk branch
* fetches ALSA headers and binaries for the target platform (choose the version that's installed in the raspi, as of now, 1.1.3)
* Builds pjproject disabling video (not needed) and webrtc (won't work on ARM)

## Configuring sound in the Pi

by default there's no input device, create a dummy one:


`sudo modprobe snd-dummy`

make sure the device is loaded upon reboot,

`sudo nano /etc/modules`

>\# /etc/modules: kernel modules to load at boot time.  
 \#  
 \# This file contains the names of kernel modules that should be loaded  
 \# at boot time, one per line. Lines beginning with "#" are ignored.  
 \# Parameters can be specified after the module name.  
  snd-dummy

## Test it
Get started with pjsua by copying the pjproject/pjsip-apps/bin/pjsua-arm-unknown-linux-gnueabihf and pjproject/pjsip-apps/bin/pjsystest-arm-unknown-linux-gnueabihf apps to your pi.

Get the list of devices by running pjsystest-arm-unknown-linux-gnueabihf
```
11:29:55.386      systest.c  Running Audio Device List  
Audio Device List  
Found 14 devices  
  0: ALSA [default:CARD=ALSA] (0/1)  
  1: ALSA [sysdefault:CARD=ALSA] (0/1)  
  2: ALSA [dmix:CARD=ALSA,DEV=0] (0/1)  
  3: ALSA [dmix:CARD=ALSA,DEV=1] (0/1)  
  4: ALSA [hw:CARD=ALSA,DEV=0] (0/1)  
  5: ALSA [hw:CARD=ALSA,DEV=1] (0/1)  
  6: ALSA [plughw:CARD=ALSA,DEV=0] (0/1)  
  7: ALSA [plughw:CARD=ALSA,DEV=1] (0/1)  
  8: ALSA [default:CARD=Dummy] (1/1)  
  9: ALSA [sysdefault:CARD=Dummy] (1/1)  
 10: ALSA [dmix:CARD=Dummy,DEV=0] (0/1)  
 11: ALSA [dsnoop:CARD=Dummy,DEV=0] (1/0)  
 12: ALSA [hw:CARD=Dummy,DEV=0] (1/1)  
 13: ALSA [plughw:CARD=Dummy,DEV=0] (1/1)  
```

Write a config file for pjsua along these lines. Note that the number for `--capture-dev` and `--playback-dev` is taken from the audio device list just mentioned.

```
#
# Logging options:
#
--log-level 5
--app-log-level 4

#
# Account 0:
#
--id sip:yourphone@telefonica.net
--registrar sip:10.31.255.134:5060
--reg-timeout 300
--proxy sip:10.31.255.134:5070
--realm telefonica.net
--username yourphone@telefonica.net
--password yourphone
--use-timer 1
--disable-stun

#
# Network settings:
#
--local-port 5060

#
# Media settings:
#
#--capture-dev=8
--playback-dev=0
#--null-audio
#--snd-auto-close 1
#using default --clock-rate 16000
#using default --quality 8
#using default --ec-tail 200
#using default --ilbc-mode 30
--rtp-port 4000

#
# User agent:
#
--max-calls 4

#
# Buddies:
#

#
# SIP extensions:
#
--use-timer 1

```
Run pjsua
```
./pjsua-arm-unknown-linux-gnueabihf --config-file ./pjsua.cfg
```
