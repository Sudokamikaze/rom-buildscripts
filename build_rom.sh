#!/bin/bash

eval $(grep CCACHEENABLE= ./config.buildscripts)
eval $(grep CCACHESIZE= ./config.buildscripts)
eval $(grep CCACHEPATH= ./config.buildscripts)
eval $(grep CURRENTDEVICE= ./config.buildscripts)
eval $(grep IFARCHLINUX= ./config.buildscripts)
eval $(grep CURRENTDEVICE= ./config.buildscripts)
eval $(grep ROOT= ./config.buildscripts)
eval $(grep MON= ./config.buildscripts)
eval $(grep HASTE= ./config.buildscripts)
eval $(grep romname= ./config.buildscripts)

if [ $IFARCHLINUX == true ]; then
    source venv/bin/activate
    export PATH="/usr/lib/jvm/java-8-openjdk/bin:$PATH"
    export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
fi

if [ $CCACHEENABLE == true ]; then
export USE_CCACHE=1
export CCACHE_DIR="$CCACHEPATH"/.ccache
prebuilts/misc/linux-x86/ccache/ccache -M "$CCACHESIZE"G
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
  logstat=$(cat log.txt | grep "failed" | awk {'print $3'})
  case "$logstat" in
    failed) 
    make installclean && mka bacon | tee -a ./err.txt
    URL=$(cat err.txt | haste)
    export HASTEURL=$URL
    export STATUS=FAILED
    ./hastebot.sh
    ;;
    *) export STATUS=OK
    ./hastebot.sh
  ;;
esac
}

function build {
  if [ -f "log.txt" ]; then
  rm log.old
  mv log.txt log.old
  fi
  croot
  breakfast "$romname"_"$CURRENTDEVICE"-userdebug
  mka bacon | tee -a ./log.txt
}

# PREPARE STAGE
. build/envsetup.sh

build
if [ "$HASTE" == "true" ]; then
haste
fi
