#!/bin/bash
. build/envsetup.sh
echo " "
echo " "
echo "======================"
echo "1. Nexus 7(grouper)"
echo "2. Xperia L(taoshan)"
echo "3. Both"
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
  3) echo "Selected both"
  device=both
  ;;
  *) echo Error
  ;;
esac

echo -n "Setup vendor and device specific files? [Y/N] "
read menu
case "$menu" in
  y|Y) echo "Creating manifest..."
  mv local_manifests .repo/
  repo sync -j5 --force-sync
  if [ $device == grouper ]; then
  breakfast grouper
elif [ $device == taoshan ]; then
  breakfast taoshan
elif [ $device == both ]; then
  breakfast taoshan
  breakfast grouper
fi
  echo Done!
  ;;
  n|N) echo "Exiting..."
  exit
  ;;
  *) echo "Error"
esac
