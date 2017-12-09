# Raspsody

## Cross Compiling pjproject
Use the [script](./cross-build-pjproject.sh)!

Summary of what the script does:
* Uses the arm-linux-gnueabihf triplet
* Defines CC, CXX, etc for autoconf
* Gets the prebuilt cross build tools from the raspberrypi tools repo (thanks pals!)
* svn checkout of pjproject's trunk branch
* builds ALSA
  - Downloads python-dev package from debian (required for ALSA)
  - Downloads ALSA lib (choose your version)
  - Builds ALSA
* Builds pjproject disabling video (not needed) and webrtc (won't work on ARM)
