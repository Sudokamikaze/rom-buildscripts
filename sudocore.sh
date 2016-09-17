#!/bin/bash
echo "Sudocore started"

function exitcore {
again=no
cpupower frequency-set -g powersave
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
