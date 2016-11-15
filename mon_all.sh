#!/bin/bash
if [ "x$(id -u)" != 'x0' ]; then
    echo 'Error: this script can only be executed by root'
    exit 1
fi

CRITTEMP=55
DATE=$(date +%H:%M:%S)

function check {
echo "---------Sensors---------"
sensors | grep °C
echo "---------HDD---------"
echo -n "Current temperature: "
temperature=$(hddtemp /dev/sda | cut -d : -f3 | sed 's/[^0-9]*//g')
echo $temperature"°C"
}

function overheat {
if [ $temperature == $CRITTEMP ]; then
  echo "Overheat..."
  killall make
  poweroff
else
  echo " "
fi
}

again=yes
while [ "$again" = "yes" ]
do
echo "Check time:" $DATE
echo " "
check
sleep 3m
echo "  "
echo "  "
check
overheat
done
