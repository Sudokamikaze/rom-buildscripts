#!/bin/bash

# ==================TUNABLE==================
export BLOCK_BASED_OTA=false # Remove this string if you don't want to disable BLOCK Baseds SHIT!
CACHEDIRPATH=/ccache/android/ # Define your dir for ccache here
CCACHESIZE=10 # Define size of cache in GB, e.x CCACHESIZE=15 or CCACHESIZE=20 without "G" letter
IFARCHLINUX=true # Define true if your distro IS ArchLinux/ Define false if your distro NOT ArchLinux
CCACHEENABLE=true # Define true if u want to use ccache / Define false if u don't wand ccache
INTELCORECPU=false # Define here if your CPU are Intel Core i3/i5/i7 sandy-bridge or newer
TWODISK=true # Define "true" here to activate var below
PATHTOTWO=/mnt/hdd # Define here dir on extrenal HDD/SSD to paralell I/O load
# ===========================================

# ==================DEVICE===================
CURRENTDEVICE=taoshan # Define here build device. E.x CURRENTDEVICE=grouper or taoshan
# ===========================================

touch /tmp/building_rom.pid
echo "Starting sudocore..."
sudo ./sudocore.sh &
sleep 10s

# PREPARE STAGE
. build/envsetup.sh

if [ $IFARCHLINUX == true ]; then
PWD=$(pwd)
BASETOPDIR=$PWD
virtualenv2 venv
ln -s /usr/lib/python2.7/* "$BASETOPDIR"/venv/lib/python2.7/
source venv/bin/activate
fi

if [ $CCACHEENABLE == true ]; then
export USE_CCACHE=1
export CCACHE_DIR="$CACHEDIRPATH".ccache
prebuilts/misc/linux-x86/ccache/ccache -M "$CCACHESIZE"G
fi

if [ $TWODISK == true ]; then
export OUT_DIR_COMMON_BASE="$PATHTOTWO"/RR/out
fi

# BUILD STAGE
croot
case "$CURRENTDEVICE" in
  taoshan) breakfast taoshan && CFLAGS='-O2 -fomit-frame-pointer' brunch taoshan
  ;;
  grouper) breakfast grouper && CFLAGS='-O2 -fomit-frame-pointer' brunch grouper
  ;;
  *) echo "Error, corrent typo"
esac

rm /tmp/building_rom.pid
sleep 3m
echo "Wait a second..."
udisksctl power-off -b /dev/sdb
fi
