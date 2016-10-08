#!/bin/bash

eval $(grep CURRENTDEVICE= ./build_rom.sh)
eval $(grep MANIFESTVERSION= ./.repo/local_manifests/roomservice.xml)

function upsources {
  make clean && make clobber
  repo sync -j 5 -f --force-sync
}

function upmanifests {
cd .repo/local_manifests
rm roomservice.xml
curl -O https://raw.githubusercontent.com/Zeroskies/local_manifests/master/roomservice_"$MANIFESTVERSION"_"$CURRENTDEVICE".xml
}

echo "============================"
echo "1. Update sources"
echo "2. Update local_manifests"
echo "============================"
echo -n "Choose an action: "
read choise
case "$choise" in
  1) upsources
  ;;
  2) upmanifests
  ;;
  *) echo "Unknown symbol."
  exit
  ;;
esac
