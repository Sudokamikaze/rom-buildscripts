#!/bin/bash
# There vars for ARCHLINUX python2 setup
PWD=$(pwd)
BASETOPDIR=$PWD

# ==================TUNABLE==================
export BLOCK_BASED_OTA=false # Remove this string if you don't want to disable BLOCK Baseds SHIT!
CACHEDIRPATH=/ccache/RR/ # Define your dir for ccache here
CCACHESIZE=10 # Define size of cache in GB
IFARCHLINUX=true # Define true if your distro IS ArchLinux/ Define false if your distro NOT ArchLinux
CCACHEENABLE=true # Define true if u want to use ccache / Define false if u don't wand ccache
# ===========================================

# PREPARE STAGE
. build/envsetup.sh

if [ $IFARCHLINUX == true ]; then
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
. build/envsetup.sh && brunch taoshan
