#!/bin/bash
. build/envsetup.sh

function blockpatch {
if [ $romver == lp ]; then
curl -O https://github.com/CyanogenMod/android_build/commit/fffc2a16c61077abf583df87f94000356f172b77.patch
cd build/core
patch < ../../fffc2a16c61077abf583df87f94000356f172b77.patch
fi
}

function prepare {
  mkdir -p .repo/local_manifests
  if [ $romver == lp ]; then
  mv local_manifests/roomservice_lp.xml .repo/roomservice.xml
elif [ $romver == mm ]; then
  mv local_manifests/roomservice_mm.xml .repo/roomservice.xml
fi
  repo sync -j 5 --force-sync
  case "$device" in
  grouper) breakfast grouper
  ;;
  taoshan) breakfast taoshan
  ;;
esac
}


echo " "
echo " "
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

echo "Select manifest version"
echo "======================"
if [ $device == grouper ]; then
echo "1. MM(6.0.1)"
echo "Grouper have very poor performance"
echo "on LP(5.1)"
fi
echo "1. MM(6.0.1)"
echo "2. LP(5.1)"
echo "======================"
echo -n "Select the version: "
read choise
case "$choise" in
  1) echo "Selected MM"
  romver=mm
  ;;
  2) echo "Selected LP"
  romver=lp
  ;;
  *) echo Error
  ;;
esac

echo -n "Setup vendor and device specific files? [Y/N] "
read menu
if [ $menu == y ]; then
  prepare
  blockpatch
elif [ $menu == Y ]; then
  prepare
  blockpatch
else
exit
fi
