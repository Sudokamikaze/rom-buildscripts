#!/bin/bash

function devicecheck {
  if [ $CURRENTDEVICE == taoshan ]; then
    device=grouper
  elif [ $CURRENTDEVICE == grouper ]; then
    device=taoshan
fi
}

function cases {
  if [ $CURRENTDEVICE == taoshan ]; then
  sed -i -e 's/CURRENTDEVICE=taoshan/CURRENTDEVICE=grouper/' ./config.buildscripts
  echo "Switched to grouper"
elif [ $CURRENTDEVICE == grouper ]; then
  sed -i -e 's/CURRENTDEVICE=grouper/CURRENTDEVICE=taoshan/' ./config.buildscripts
  echo "Switched to taoshan"
fi
}


eval $(grep CURRENTDEVICE= ./config.buildscripts)
devicecheck
echo -n "Current device in config.buildscripts: "
echo $CURRENTDEVICE
echo "==============================="
echo -n "Do you wan't switch to $device? [Y/N]: "
read choise
case "$choise" in
  y|Y) cases
  ;;
  n|N) exit
  ;;
esac
