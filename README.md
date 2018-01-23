# Raspsody

## Cross Compiling pjproject

Use the [script](./cross-build-pjproject.sh)!

Summary of what the script does:
* Uses the arm-linux-gnueabihf triplet
* Defines CC, CXX, etc for autoconf
* Gets the prebuilt cross build tools from the raspberrypi tools repo (thanks pals!)
* svn checkout of pjproject's trunk branch
* Builds pjproject disabling video (not needed) and webrtc (won't work on ARM)

Once the build is finished, copy all the contents of the install folder to the destination machine (install/usr/local --> /usr/local)

Get started with pjsua by copying the trunk/pjsip-apps/bin/pjsua-arm-unknown-linux-gnueabihf app to your pi and invoke it with

```./pjsua-arm-unknown-linux-gnueabihf --config-file ./pjsua.cfg```

Where the config file should be something along these lines:

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
--snd-auto-close 1
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
