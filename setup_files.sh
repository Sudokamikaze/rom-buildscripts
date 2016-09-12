#!/bin/bash
. build/envsetup.sh

#  EDIT THERE !!
romver=lp # If u define there "lp" it will download patch to enable/disable block based from cm 13
# ==============

if [ $romver == lp ]; then
curl -O https://github.com/CyanogenMod/android_build/commit/fffc2a16c61077abf583df87f94000356f172b77.patch
cd core/
patch < ../fffc2a16c61077abf583df87f94000356f172b77.patch
fi

function prepare{
  mv local_manifests .repo/
  repo sync -j 5 --force-sync
  case "$device" in
  grouper) breakfast grouper
  ;;
  taoshan) breakfast taoshan
  ;;
  both) breakfast taoshan && breakfast grouper
  ;;
esac
}


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
if [ $menu == y ]; then
  prepare
elif [ $menu == Y ]; then
  prepare
else
exit
fi
