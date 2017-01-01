#!/bin/bash

eval $(grep CCACHEENABLE= ./config.buildscripts)
eval $(grep cachemain= ./config.buildscripts)
eval $(grep CCACHESIZE= ./config.buildscripts)
eval $(grep CACHEMAINPATH= ./config.buildscripts)
eval $(grep CACHERESERVEPATH= ./config.buildscripts)
eval $(grep CURRENTDEVICE= ./config.buildscripts)
eval $(grep IFARCHLINUX= ./config.buildscripts)
eval $(grep CURRENTDEVICE= ./config.buildscripts)
eval $(grep BLOCK_BASED_OTA= ./config.buildscripts)
eval $(grep BUILDKITKAT= ./config.buildscripts)

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

if [ "$cachemain" == "true" ]; then
export CCACHE_DIR="$CACHEMAINPATH"/.ccache
elif [ "$cachemain" == "false" ]; then
export CCACHE_DIR="$CACHERESERVEPATH"/.ccache
fi
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

if [ "$BLOCK_BASED_OTA" == "false" ]; then
export BLOCK_BASED_OTA=false
fi

# BUILD STAGE
buildfunct
