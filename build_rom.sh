#!/bin/bash

eval $(grep CCACHEENABLE= ./config.buildscripts)
eval $(grep CCACHESIZE= ./config.buildscripts)
eval $(grep CCACHEPATH= ./config.buildscripts)
eval $(grep CURRENTDEVICE= ./config.buildscripts)
eval $(grep IFARCHLINUX= ./config.buildscripts)
eval $(grep CURRENTDEVICE= ./config.buildscripts)
eval $(grep BLOCK_BASED_OTA= ./config.buildscripts)
eval $(grep BUILDKITKAT= ./config.buildscripts)
eval $(grep ROOT= ./config.buildscripts)
eval $(grep MON= ./config.buildscripts)

case "$IFARCHLINUX" in
  true) source venv/bin/activate
  if [ "$BUILDKITKAT" == "false" ]; then
    export PATH="/usr/lib/jvm/java-8-openjdk/bin:$PATH"
    export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
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

if [ "$ROOT" == "true" ]; then
export WITH_SU=true
fi

if [ "$MON" == "true" ]; then
echo "Mon mode enabled"
echo -n "Enter sudo password: "
read -s password
echo $password | sudo -S ./mon_all.sh -d &
unset $password
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
