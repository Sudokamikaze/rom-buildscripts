#!/bin/bash

function upsources {
  make clean
  repo sync --force-sync
}

function updevice {
  cd device/sony && rm -rf taoshan
  git clone https://github.com/Sudokamikaze/android_device_sony_taoshan.git taoshan
  cd ../../
}

function upvendor {
  cd vendor/sony && rm -rf taoshan
  git clone https://github.com/Sudokamikaze/proprietary_vendor_sony.git sony -b taoshan
  cd ../
}

. build/envsetup.sh
echo " "
echo " "
echo ========================================
echo "1. Update sources"
echo "2. Update device files"
echo "3. Update vendor files"
echo "4. Update all(sources,device,vendor)"
echo ========================================
echo -n "Choose an option: "
read menu
case "$menu" in
  1) echo "Updating sources"
  upsources
  ;;
  2) echo "Updating device files..."
  updevice
  breakfast cm_taoshan-userdebug
  echo "Done!"
  ;;
  3) echo "Updating vendor files..."
  upvendor
  breakfast cm_taoshan-userdebug
  echo "Done!"
  ;;
  4) echo "Updating all"
  upsources
  updevice
  upvendor
  breakfast cm_taoshan-userdebug
  echo "Done!"
  ;;
  *) echo "Unknown symbol.."
esac
