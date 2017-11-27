#!/bin/bash

eval $(grep CCACHEENABLE= ./config.buildscripts)
eval $(grep CCACHESIZE= ./config.buildscripts)
eval $(grep CCACHEPATH= ./config.buildscripts)
eval $(grep DEVICE= ./config.buildscripts)
eval $(grep ARCHLINUX= ./config.buildscripts)
eval $(grep ROOT= ./config.buildscripts)
eval $(grep MON= ./config.buildscripts)
eval $(grep ROM= ./config.buildscripts)
eval $(grep HASTE_UPLOAD= ./config.buildscripts)

function apply_values {
  if [ $ARCHLINUX == "true" ]; then
      source venv/bin/activate
      export PATH="/usr/lib/jvm/java-8-openjdk/bin:$PATH"
      export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
  fi

  if [ $CCACHEENABLE == "true" ]; then
      export USE_CCACHE=1
      export CCACHE_DIR="$CCACHEPATH"/.ccache
      prebuilts/misc/linux-x86/ccache/ccache -M "$CCACHESIZE"G
  fi

  if [ "$ROM" == "lineage" ]; then
	if [ "$ROOT" == "true" ]; then
      export WITH_SU=true
fi
fi

if [ "$MON" == "true" ]; then
echo "Monitoring mode enabled"
echo -n "Enter sudo password: "
read -s password
echo $password | sudo -S ./mon.sh &
unset $password
fi
}

function haste {
  case "$(cat log.txt | grep "failed" | awk {'print $3'})" in
    failed)
    make installclean && mka bacon | tee -a ./err.txt
    export HASTEURL=$(cat err.txt | haste)
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
  breakfast "$ROM"_"$DEVICE"-userdebug
  mka bacon | tee -a ./log.txt
}

# PREPARE STAGE
. build/envsetup.sh

apply_values
build
if [ "$HASTE" == "true" ]; then
haste
fi
