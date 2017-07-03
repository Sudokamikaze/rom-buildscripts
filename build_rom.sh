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
eval $(grep romname= ./config.buildscripts)


case "$IFARCHLINUX" in
  true) source venv/bin/activate
    export PATH="/usr/lib/jvm/java-8-openjdk/bin:$PATH"
    export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
  ;;
esac

if [ $CCACHEENABLE == true ]; then
export USE_CCACHE=1
export CCACHE_DIR="$CCACHEPATH"/.ccache
export CCACHE_SLOPPINESS=file_macro,time_macros,include_file_mtime,include_file_ctime,file_stat_matches
prebuilts/misc/linux-x86/ccache/ccache -M "$CCACHESIZE"G
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

function haste {
  if [ -f "log.txt" ]; then
  rm log.txt
  fi
  logstat=$(cat log.txt | grep "failed" | awk {'print $3'})
  case "$logstat" in
    failed) make installclean && build
    URL=$(cat log.txt | haste)
    export HASTEURL=$URL
    ;;
    *) ./BuildStat/main.sh
  ;;
esac
}

function build {
  croot
  case "$CURRENTDEVICE" in
    mako) breakfast "$romname"_mako-userdebug
    ;;
    grouper) breakfast "$romname"_grouper-userdebug
    ;;
    *) echo "Error, corrent typo"
  esac
  mka bacon | tee -a ./log.txt
}

# PREPARE STAGE
. build/envsetup.sh

build
if [ "$HASTE" == "true" ]; then
haste
fi
