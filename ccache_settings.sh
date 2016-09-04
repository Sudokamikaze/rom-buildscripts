#!/bin/bash
eval $(grep CCACHEENABLE= ./build_rom.sh)
if [ "$CCACHEENABLE" != 'true' ]; then
    echo 'Error: CCache disabled in build_taoshan. Exiting...'
    exit 1
fi

eval $(grep CACHEDIRPATH= ./build_rom.sh)

export USE_CCACHE=1
export CCACHE_DIR="$CACHEDIRPATH".ccache

echo ================================
echo "1. Check CCACHE size"
echo "2. Cleanup CCACHE"
echo "3. Define new CCACHE max size"
echo ================================
echo -n "Choose an action: "
read menu
case "$menu" in
  1) echo " "
  prebuilts/misc/linux-x86/ccache/ccache -s
  ;;
  2) echo "Cleaning ccache"
  prebuilts/misc/linux-x86/ccache/ccache -c
  ;;
  3) echo -n "Enter size in GB: "
  read size
  echo " "
  prebuilts/misc/linux-x86/ccache/ccache -M "$size"G
  ;;
  *) echo Error
  ;;
esac
