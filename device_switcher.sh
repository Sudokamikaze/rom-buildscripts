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
  sed -i -e 's/CURRENTDEVICE=taoshan/CURRENTDEVICE=grouper/' ./build_rom.sh
  echo "Switched to grouper"
elif [ $CURRENTDEVICE == grouper ]; then
  sed -i -e 's/CURRENTDEVICE=grouper/CURRENTDEVICE=taoshan/' ./build_rom.sh
  echo "Switched to taoshan"
fi
}


eval $(grep CURRENTDEVICE= ./build_rom.sh)
devicecheck
echo -n "Current device in build_rom: "
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
