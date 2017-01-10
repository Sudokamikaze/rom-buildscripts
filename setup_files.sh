#!/bin/bash
eval $(grep IFARCHLINUX= ./config.buildscripts)
. build/envsetup.sh

function pythonvenv {
  rm -rf venv
  PWD=$(pwd)
  BASETOPDIR=$PWD
  virtualenv2 venv
  ln -s /usr/lib/python2.7/* "$BASETOPDIR"/venv/lib/python2.7/
}

function manifestdownload {
  mkdir -p .repo/local_manifests
  cd .repo/local_manifests
  curl -O https://raw.githubusercontent.com/Zeroskies/local_manifests/master/"$gitmanifests".xml
  mv "$gitmanifests".xml roomservice.xml
  repo sync -j 5 --force-sync
  case "$device" in
  grouper) breakfast grouper
  ;;
  taoshan) breakfast taoshan
  ;;
esac
cd ../../
}


function manifestprepare {
if [ $device == grouper ]; then
case "$romver" in
  mm) gitmanifests=roomservice_mm_grouper
  ;;
  kk) gitmanifests=roomservice_kk_grouper
  mkdir makedir && cd makedir
  ln -s /usr/sbin/make-3.81 ./make
  cd ..
  ;;
esac
elif [ $device == taoshan ]; then
case "$romver" in
  mm) gitmanifests=roomservice_mm_taoshan
  ;;
  lp) gitmanifests=roomservice_lp_taoshan
  ;;
esac
fi
}

echo " "
echo " "
echo "================================"
echo "1. Nexus 7(grouper)"
echo "2. Xperia L(taoshan)"
echo "================================"
echo "fixpython. Recreate python venv"
echo "================================"
echo -n "Select the action: "
read choise
case "$choise" in
  1) device=grouper
  ;;
  2) device=taoshan
  ;;
  fixpython) echo "Fixin'.."
  rm -rf venv
  pythonvenv
  echo "Done!"
  exit
  ;;
  *) echo Error
  ;;
esac

echo " "
echo " "

echo "Selected device: $device"
echo "========================"
case "$device" in
  taoshan)
echo "1. MM(6.0.1)"
echo "2. LP(5.1)"
  ;;
  grouper)
echo "1. MM(6.0.1)"
echo "2. KK(4.4.4)"
  ;;
esac
echo "========================"
echo -n "Select the version: "
read choise
if [ "$device" == "grouper" ]; then
  case "$choise" in
    1) romver=mm
    ;;
    2) romver=kk
    ;;
  esac
elif [ "$device" == "taoshan" ]; then
  case "$choise" in
    1) romver=mm
    ;;
    2) romver=lp
    ;;
  esac
fi

manifestprepare

echo -n "All the preparation was successful, do you want to proceed? [Y/N]: "
read menu
case "$menu" in
  y|Y) manifestdownload
  ;;
  n|N) exit
  ;;
  *) echo "Unknown symbol"
  exit
  ;;
esac

if [ $IFARCHLINUX == true ]; then
echo "Creating python venv"
pythonvenv
fi
