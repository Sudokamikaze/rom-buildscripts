#!/bin/bash
. build/envsetup.sh
echo " "
echo " "
echo "Setup vendor and device specific files? [Y/N] "
read menu
case "$menu" in
  y|Y) echo "Setuping device specific files...."
  breakfast taoshan
  cd device/sony
  rm -rf taoshan
  git clone https://github.com/Sudokamikaze/android_device_sony_taoshan.git taoshan
  cd ..
  echo "Setuping vendor files...."
  cd vendor
  git clone https://github.com/Sudokamikaze/proprietary_vendor_sony.git sony -b taoshan
  cd ../
  breakfast cm_taoshan-userdebug
  echo Done!
  ;;
  n|N) echo "Exiting..."
  exit
  ;;
  *) echo "Error"
esac
