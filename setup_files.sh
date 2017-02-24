#!/bin/bash
eval $(grep IFARCHLINUX= ./config.buildscripts)

function pythonvenv {
  local check_var=$(ls | grep "venv")
  if [ "$check_var" != "venv" ];
  PWD=$(pwd)
  virtualenv2 venv
  ln -s /usr/lib/python2.7/* "$PWD"/venv/lib/python2.7/
fi
else
  echo "Venv already created"
  exit 1
fi
}

function get_manifest {
  mkdir -p .repo/local_manifests
  cd .repo/local_manifests
  wget -q -O roomservice.xml https://raw.githubusercontent.com/Zeroskies/local_manifests/master/"$gitmanifests".xml
  repo sync -j 5 --force-sync
  cd ../../
  . build/envsetup.sh
  case "$device" in
  grouper) breakfast grouper
  ;;
  taoshan) breakfast taoshan
  ;;
esac
}

echo "========================="
echo "1. Xperia L(taoshan)"
echo "2. Nexus 7(grouper)"
echo "========================="
echo "3. Fix python venv(for archlinux)"
echo "========================="
echo -n "Choose device: "
read choise
case "$choise" in
  1) choised=taoshan
  ;;
  2) choised=grouper
  ;;
  3) rm -rf venv
  pythonvenv
  ;;
esac

case "$choised" in
  taoshan)
  desc1="MM. Marhsmallow(6.0.1)"
  desc2="LP. Lollipop(5.1)"
  ;;
  grouper)
  desc1="MM. Marhsmallow(6.0.1)"
  desc2="KK. Kitkat(4.4.4)"
  ;;
esac

echo "There manifests available and provided by Zeroskies"
echo "========================="
echo $desc1
echo $desc2
echo "========================="
echo -n "Choose version: "
read version
case "$version" in
  MM|mm) romver=mm
  gitmanifests=roomservice_"$romver"_"$choised"
  ;;
  LP|lp) romver=lp
  gitmanifests=roomservice_"$romver"_"$choised"
  ;;
  KK|kk)
  mkdir makedir && cd makedir
  ln -s /usr/sbin/make-3.81 ./make
  romver=kk
  gitmanifests=roomservice_"$romver"_"$choised"
  ;;
esac

manifest_get

if [ $IFARCHLINUX == true ]; then
echo "Creating python venv"
pythonvenv
fi
