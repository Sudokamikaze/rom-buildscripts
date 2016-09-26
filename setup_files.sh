#!/bin/bash
. build/envsetup.sh

function pythonvenv {
  virtualenv2 venv
  ln -s /usr/lib/python2.7/* "$BASETOPDIR"/venv/lib/python2.7/
}

function prepare {
  mkdir -p .repo/local_manifests
  if [ $romver == lp ]; then
  cd .repo/local_manifests
  curl -O https://raw.githubusercontent.com/Zeroskies/local_manifests/master/"$gitmanifests".xml
  mv "$gitmanifests".xml roomservice.xml
elif [ $romver == mm ]; then
  cd .repo/local_manifests
  curl -O https://raw.githubusercontent.com/Zeroskies/local_manifests/master/"$gitmanifests".xml
  mv "$gitmanifests".xml roomservice.xml
fi
  repo sync -j 5 --force-sync
  case "$device" in
  grouper) breakfast grouper
  ;;
  taoshan) breakfast taoshan
  ;;
esac
}

function displaymenu {
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
  if [ $device == grouper ]; then
    case "$choise" in
      1) echo "Selected MM"
      romver=mm
      ;;
      *) echo Error
      ;;
    esac
fi
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
}

function prepareman {
if [ $device == grouper ]; then
gitmanifests=roomservice_mm_grouper
elif [ $device == taoshan ]; then
case "$romver" in
  mm) gitmanifests=roomservice_mm_taoshan
  ;;
  lp) gitmanifests=roomservice_lp_taoshan
esac
fi
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

echo " "
echo " "

displaymenu
prepareman

echo -n "Setup vendor and device specific files? [Y/N] "
read menu
case "$menu" in
  y|Y) prepare
  ;;
  n|N) exit
  ;;
  *) echo "Unknown symbol"
  exit
  ;;
esac

echo "Creating python venv"
sleep 2
pythonvenv
