#!/bin/bash
PIDFILE=/tmp/building_rom.pid
echo "Sudo is need to be root and wait build_rom.sh process end"
eval $(grep INTELCORECPU= ./build_rom.sh)
eval $(grep TWODISK= ./build_rom.sh)

function exitcore {
again=no
if [ $INTELCORECPU == true ]; then
cpupower frequency-set -g powersave
fi
if [ $TWODISK == true ]; then
umount $PATHTOTWO
fi
}

if [ $INTELCORECPU == true ]; then
cpupower frequency-set -g performance
fi

again=yes
while [ "$again" = "yes" ]
do
if [ ! -f $PIDFILE ]
then
exitcore
fi
sleep 2m
done
