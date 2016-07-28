#!/bin/bash
. build/envsetup.sh
echo ================================
echo "1. Update sources"
echo "2. Update device files"
echo "3. Update vendor files"
echo ================================
echo -n "Choose an option: "
read menu
case "$menu" in
  1) echo "Updating sources"
  make clean
  repo sync --force-sync
  ;;
  2) echo "Updating device files..."
  cd device/sony && rm -rf taoshan
  git clone https://github.com/Sudokamikaze/android_device_sony_taoshan.git taoshan
  cd ../../
  breakfast cm_taoshan-userdebug
  echo "Done!"
  ;;
  3) echo "Updating vendor files..."
  cd vendor/sony && rm -rf taoshan
  git clone https://github.com/TheMuppets/proprietary_vendor_sony.git
  cd proprietary_vendor_sony
  mv taoshan ../ && cd ..
  rm -rf proprietary_vendor_sony
  breakfast cm_taoshan-userdebug
  echo "Done!"
  ;;
  *) echo "Unknown symbol.."
esac
