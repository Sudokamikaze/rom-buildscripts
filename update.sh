#!/bin/bash

function upsources {
  make clean && make clobber
  repo sync -f --force-sync
}

function upvendor {
  if [ $device == grouper ]; then
    cd vendor && rm -rf asus
    git clone https://github.com/TheMuppets/proprietary_vendor_asus.git asus -b cm-13.0
    cd ../
  elif [ $device == taoshan ]; then
  cd vendor && rm -rf sony
  git clone https://github.com/TheMuppets/proprietary_vendor_sony.git sony -b cm-13.0
  cd ../
fi
}

echo "======================"
echo "1. Nexus 7(grouper)"
echo "2. Xperia L(taoshan)"
echo "======================"
echo -n "Select the device: "
read choise
case "$choise" in
  1) echo "Selected grouper"
  device=grouper
  ;;
  2) echo "Selected taoshan"
  device=taoshan
  ;;
  *) echo Error
  ;;
esac
. build/envsetup.sh
echo " "
echo " "
echo ========================================
echo "1. Update sources(including device files)"
echo "2. Update vendor files"
echo "3. Update all(sources,vendor)"
echo ========================================
echo -n "Choose an option: "
read menu
case "$menu" in
  1) echo "Updating sources"
  upsources
  ;;
  2) echo "Updating vendor files..."
  upvendor
  echo "Done!"
  ;;
  3) echo "Updating all"
  upsources
  upvendor
  if [ $device == grouper ]; then
  breakfast grouper
elif [ $device == taoshan ]; then
  breakfast taoshan
fi
  echo "Done!"
  ;;
  *) echo "Unknown symbol.."
esac
