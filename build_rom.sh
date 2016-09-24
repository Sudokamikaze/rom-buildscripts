#!/bin/bash

# ==================TUNABLE==================
export BLOCK_BASED_OTA=false # Remove this string if you don't want to disable BLOCK Baseds SHIT!
CACHEDIRPATH=/ccache/android/ # Define your dir for ccache here
CCACHESIZE=10 # Define size of cache in GB, e.x CCACHESIZE=15 or CCACHESIZE=20 without "G" letter
IFARCHLINUX=true # Define true if your distro IS ArchLinux/ Define false if your distro NOT ArchLinux
CCACHEENABLE=true # Define true if u want to use ccache / Define false if u don't wand ccache
# export OUT_DIR_COMMON_BASE=/mnt/hdd/out # Define there or comment this var
# ===========================================

# ==================DEVICE===================
CURRENTDEVICE=taoshan # Define here build device. E.x CURRENTDEVICE=grouper or taoshan
# ===========================================

# PREPARE STAGE
. build/envsetup.sh

if [ $IFARCHLINUX == true ]; then
PWD=$(pwd)
BASETOPDIR=$PWD
source venv/bin/activate
fi

if [ $CCACHEENABLE == true ]; then
export USE_CCACHE=1
export CCACHE_DIR="$CACHEDIRPATH".ccache
prebuilts/misc/linux-x86/ccache/ccache -M "$CCACHESIZE"G
fi

# BUILD STAGE
croot
case "$CURRENTDEVICE" in
  taoshan) breakfast taoshan && CFLAGS='-O2 -fomit-frame-pointer' mka bacon
  ;;
  grouper) breakfast grouper && CFLAGS='-O2 -fomit-frame-pointer' mka bacon
  ;;
  *) echo "Error, corrent typo"
esac
