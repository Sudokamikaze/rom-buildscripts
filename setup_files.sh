#!/bin/bash
. build/envsetup.sh
echo " "
echo " "
echo -n "Setup vendor and device specific files? [Y/N] "
read menu
case "$menu" in
  y|Y) echo "Creating manifest..."
  cp local_manifests/taoshan.xml .repo/local_manifests/roomservice.xml
  echo "Setuping vendor files..."
  cd vendor
  git clone https://github.com/TheMuppets/proprietary_vendor_sony.git sony -b cm-13.0
  cd ../
  breakfast taoshan
  echo Done!
  ;;
  n|N) echo "Exiting..."
  exit
  ;;
  *) echo "Error"
esac
