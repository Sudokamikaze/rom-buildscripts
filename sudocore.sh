#!/bin/bash
echo "Sudocore started"
eval $(grep INTELCORECPU= ./build_rom.sh)

function exitcore {
again=no
if [ $INTELCORECPU == true ]; then
cpupower frequency-set -g powersave
fi
umount /dev/sdb
udisksctl power-off -b /dev/sdb
}

cpupower frequency-set -g performance

again=yes
while [ "$again" = "yes" ]
do
if [ ! -f /tmp/building_rom.pid ]
then
exitcore
fi
sleep 2m
done
