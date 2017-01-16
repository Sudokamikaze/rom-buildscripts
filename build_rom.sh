#!/bin/bash

eval $(grep CCACHEENABLE= ./config.buildscripts)
eval $(grep CCACHESIZE= ./config.buildscripts)
eval $(grep CCACHEPATH= ./config.buildscripts)
eval $(grep CURRENTDEVICE= ./config.buildscripts)
eval $(grep IFARCHLINUX= ./config.buildscripts)
eval $(grep CURRENTDEVICE= ./config.buildscripts)
eval $(grep BLOCK_BASED_OTA= ./config.buildscripts)
eval $(grep BUILDKITKAT= ./config.buildscripts)

case "$IFARCHLINUX" in
  true) source venv/bin/activate
  if [ "$BUILDKITKAT" != "true" ]; then
    export PATH="/usr/lib/jvm/java-7-openjdk/bin:$PATH"
    export JAVA_HOME=/usr/lib/jvm/java-7-openjdk
  else
    export PATH="/usr/lib/jvm/java-6-jre/jre/bin:$PATH"
    export JAVA_HOME=/usr/lib/jvm/java-6-jre/jre
  fi
  ;;
esac

if [ $CCACHEENABLE == true ]; then
export USE_CCACHE=1
export CCACHE_DIR="$CCACHEPATH"/.ccache
export CCACHE_SLOPPINESS=file_macro,time_macros,include_file_mtime,include_file_ctime,file_stat_matches
prebuilts/misc/linux-x86/ccache/ccache -M "$CCACHESIZE"G
fi

if [ "$BUILDKITKAT" == "true" ]; then
  pwdvar=$(pwd)
  export PATH="$pwdvar/makedir:$PATH"
fi

if [ "$BLOCK_BASED_OTA" == "false" ]; then
export BLOCK_BASED_OTA=false
fi

# PREPARE STAGE
. build/envsetup.sh

croot
case "$CURRENTDEVICE" in
  taoshan) breakfast taoshan
  ;;
  grouper) breakfast grouper
  ;;
  *) echo "Error, corrent typo"
esac
mka bacon
