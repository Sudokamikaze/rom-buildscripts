#!/bin/bash
eval $(grep CCACHEENABLE= ./build_rom.sh)
eval $(grep CACHEMAINPATH= ./build_rom.sh)
eval $(grep CACHERESERVEPATH= ./build_rom.sh)
eval $(grep cachemain= ./build_rom.sh)

if [ "$CCACHEENABLE" != 'true' ]; then
    echo 'Error: CCache disabled in build_rom.sh Exiting...'
    exit 1
fi

export USE_CCACHE=1
if [ "$cachemain" == "true" ]; then
export CCACHE_DIR="$CACHEMAINPATH"/.ccache
elif [ "$cachemain" == "false" ]; then
export CCACHE_DIR="$CACHERESERVEPATH"/.ccache
fi

function define {
if [ "$cachemain" == "true" ]; then
  current=MAIN
  to=RESERVE
elif [ "$cachemain" == "false" ]; then
  current=RESERVE
  to=MAIN
fi
}

function switch {
  if [ "$current" == "MAIN" ]; then
  sed -i -e 's/cachemain=true/cachemain=false/' ./build_rom.sh
  echo "Switched to RESERVE"
elif [ "$current" == "RESERVE" ]; then
  sed -i -e 's/cachemain=false/cachemain=true/' ./build_rom.sh
  echo "Switched to MAIN"
fi
}

echo ================================
echo "1. Check CCACHE size"
echo "2. Cleanup CCACHE(with rm -rf)"
echo "3. Define new CCACHE max size"
echo "4. Switch Cache"
echo ================================
echo -n "Choose an action: "
read menu
case "$menu" in
  1) echo " "
  prebuilts/misc/linux-x86/ccache/ccache -s
  ;;
  2) echo "Cleaning ccache"
  if [ "$cachemain" == "true" ]; then
  cd $CACHEMAINPATH
  elif [ "$cachemain" == "false" ]; then
  cd $CACHERESERVEPATH
  fi
  rm -rf .ccache/
  ;;
  3) echo -n "Enter size in GB: "
  read size
  echo " "
  prebuilts/misc/linux-x86/ccache/ccache -M "$size"G
  ;;
  4) define
  echo "Current cache path is $current"
  echo -n "Do you want switch to $to?: "
  read choise
  if [ "$choise" == "y" ]; then
  switch
elif [ "$choise" == "Y" ]; then
  switch
fi
  ;;
  *) echo Error
  ;;
esac
