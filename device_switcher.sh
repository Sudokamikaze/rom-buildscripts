#!/bin/bash

function switchcheck {
  if [ $CURRENTDEVICE == taoshan ]; then
    echo -n "Do you wan't switch to grouper? [Y/N]: "
  elif [ $CURRENTDEVICE == grouper ]; then
    echo -n "Do you wan't switch to taoshan? [Y/N]: "
  fi
read device
}

function cases {
  if [ $CURRENTDEVICE == taoshan ]; then
  sed -i -e 's/CURRENTDEVICE=taoshan/CURRENTDEVICE=grouper/' ./build_rom.sh
  echo "Switched to grouper"
elif [ $CURRENTDEVICE == grouper ]; then
  sed -i -e 's/CURRENTDEVICE=grouper/CURRENTDEVICE=taoshan/' ./build_rom.sh
  echo "Switched to taoshan"
fi
}


eval $(grep CURRENTDEVICE= ./build_rom.sh)
echo -n "Current device in build_rom: "
echo $CURRENTDEVICE
echo "==============================="
switchcheck
case "$device" in
  y|Y) cases
  ;;
  n|N) exit
  ;;
esac
