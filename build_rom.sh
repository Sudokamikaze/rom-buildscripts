#!/bin/bash

# ==================TUNABLE==================
export BLOCK_BASED_OTA=false # Remove this string if you don't want to disable BLOCK Baseds SHIT!
CACHEDIRPATH=/ccache/android/ # Define your dir for ccache here
CCACHESIZE=10 # Define size of cache in GB, e.x CCACHESIZE=15 or CCACHESIZE=20 without "G" letter
IFARCHLINUX=true # Define true if your distro IS ArchLinux/ Define false if your distro NOT ArchLinux
CCACHEENABLE=true # Define true if u want to use ccache / Define false if u don't wand ccache
BUILDKITKAT=auto # Define true here if you building 4.4.4 and you are on archlinux(install make-3.81 and jre6 from aur)
# export OUT_DIR_COMMON_BASE=/mnt/hdd/out # Define there or comment this var
# ===========================================

# ==================DEVICE===================
CURRENTDEVICE=taoshan # Define here build device. E.x CURRENTDEVICE=grouper or taoshan
# ===========================================

function buildfunct {
  croot
  case "$CURRENTDEVICE" in
    taoshan) breakfast taoshan
    ;;
    grouper) breakfast grouper
    ;;
    *) echo "Error, corrent typo"
  esac
  mka bacon
}

# PREPARE STAGE
. build/envsetup.sh

if [ $IFARCHLINUX == true ]; then
source venv/bin/activate
export PATH="/usr/lib/jvm/java-7-openjdk/bin:$PATH"
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk
fi

if [ $CCACHEENABLE == true ]; then
export USE_CCACHE=1
export CCACHE_DIR="$CACHEDIRPATH"/.ccache
export CCACHE_SLOPPINESS=file_macro,time_macros,include_file_mtime,include_file_ctime,file_stat_matches
prebuilts/misc/linux-x86/ccache/ccache -M "$CCACHESIZE"G
fi

if [ "$BUILDKITKAT" == "true" ]; then
pwdvar=$(pwd)
export PATH="/usr/lib/jvm/java-6-jre/jre/bin:$PATH"
export JAVA_HOME=/usr/lib/jvm/java-6-jre/jre
export PATH="$pwdvar/makedir:$PATH"
elif [ "$BUILDKITKAT" == "auto" ]; then
checkdir=$(ls | grep makedir)
if [ "$checkdir" == "makedir" ]; then
pwdvar=$(pwd)
export PATH="/usr/lib/jvm/java-6-jre/jre/bin:$PATH"
export JAVA_HOME=/usr/lib/jvm/java-6-jre/jre
export PATH="$pwdvar/makedir:$PATH"
fi
fi

# BUILD STAGE
buildfunct
