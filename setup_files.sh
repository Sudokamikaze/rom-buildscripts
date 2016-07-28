#!/bin/bash
. build/envsetup.sh
echo "Setup vendor and device specific files? [Y/N] "
read menu
case "$menu" in
  y|Y) echo "Setuping device specific files...."
  cd device && mkdir sony && cd sony
  git clone https://github.com/Sudokamikaze/android_device_sony_taoshan.git taoshan
  cd ../..
  echo "Setuping vendor files...."
  cd vendor && mkdir sony && cd sony
  git clone https://github.com/TheMuppets/proprietary_vendor_sony.git
  cd proprietary_vendor_sony
  mv taoshan ../ && cd ..
  rm -rf proprietary_vendor_sony
  breakfast cm_taoshan-userdebug
  echo Done!
  ;;
  n|N) echo "Exiting..."
  exit
  ;;
  *) echo "Error"
esac
