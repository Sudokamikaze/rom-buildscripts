#!/bin/bash

function upsources {
  make clean
  repo sync -f --force-sync
}

function upvendor {
  cd vendor&& rm -rf sony
  git clone https://github.com/TheMuppets/proprietary_vendor_sony.git sony
  cd ../
}

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
  breakfast taoshan
  echo "Done!"
  ;;
  3) echo "Updating all"
  upsources
  upvendor
  breakfast taoshan
  echo "Done!"
  ;;
  *) echo "Unknown symbol.."
esac
