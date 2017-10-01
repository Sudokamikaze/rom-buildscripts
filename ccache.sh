#!/bin/bash

eval $(grep CCACHEENABLE= ./config.buildscripts)
eval $(grep CCACHEPATH= ./config.buildscripts)

  if [ "$CCACHEENABLE" != 'true' ]; then
      echo 'Error: CCache disabled in config.buildscripts Exiting...'
      exit 1
  fi
  export USE_CCACHE=1
  export CCACHE_DIR="$CCACHEPATH"/.ccache
  echo ================================
  echo "1. Check CCACHE size"
  echo "2. Cleanup CCACHE(with rm -rf)"
  echo "3. Temportaly define CCACHE max size"
  echo ================================
  echo -n "Choose an action: "
  read menu
  case "$menu" in
    1) echo " "
    prebuilts/misc/linux-x86/ccache/ccache -s
    ;;
    2) echo "Cleaning ccache"
    cd $CCACHEPATH
    rm -rf .ccache/
    ;;
    3) echo -n "Enter size in GB: "
    read size
    echo " "
    prebuilts/misc/linux-x86/ccache/ccache -M "$size"G
    ;;
    *) echo Error
    ;;
  esac

function device_switch {
  if [ $CURRENTDEVICE == mako ]; then
    device=grouper
  elif [ $CURRENTDEVICE == grouper ]; then
    device=mako
  fi
  echo -n "Current device in config.buildscripts: "
  echo $CURRENTDEVICE
  echo "==============================="
  echo -n "Do you want switch to $device? [Y/N]: "
  read choise
  case "$choise" in
    y|Y) configure_device
    ;;
    n|N) exit
    ;;
  esac
}

