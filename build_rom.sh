#!/bin/bash

# ==================TUNABLE==================
export BLOCK_BASED_OTA=false # Remove this string if you don't want to disable BLOCK Baseds SHIT!
CACHEDIRPATH=/ccache/android/ # Define your dir for ccache here
CCACHESIZE=10 # Define size of cache in GB, e.x CCACHESIZE=15 or CCACHESIZE=20 without "G" letter
IFARCHLINUX=true # Define true if your distro IS ArchLinux/ Define false if your distro NOT ArchLinux
CCACHEENABLE=true # Define true if u want to use ccache / Define false if u don't wand ccache
# ===========================================

# ==================DEVICE===================
CURRENTDEVICE=taoshan # Define here build device. E.x CURRENTDEVICE=grouper or taoshan
# ===========================================


# PREPARE STAGE
. build/envsetup.sh

if [ $IFARCHLINUX == true ]; then
PWD=$(pwd)
BASETOPDIR=$PWD
virtualenv2 venv
ln -s /usr/lib/python2.7/* "$BASETOPDIR"/venv
source venv/bin/activate
fi

if [ $CCACHEENABLE == true ]; then
export USE_CCACHE=1
export CCACHE_DIR="$CACHEDIRPATH".ccache
prebuilts/misc/linux-x86/ccache/ccache -M "$CCACHESIZE"G
fi

# BUILD STAGE
croot
if [ $CURRENTDEVICE == taoshan ]; then
breakfast taoshan && CFLAGS='-O2 -fomit-frame-pointer' mka taoshan
elif [ $CURRENTDEVICE == grouper ]; then
breakfast grouper && CFLAGS='-O2 -fomit-frame-pointer' mka grouper
else
  echo "Error"
fi
