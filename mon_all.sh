#!/bin/bash

# Define true if you on laptop
HAVEBATTERY=true

# Define bellow your HDD critical temperature
CRITTEMP=55
DATE=$(date +%H:%M:%S)


function check {
echo "---------Sensors---------"
sensors | grep °C
echo "----------HDD--------"
echo -n "Current temperature: "
temperature=$(hddtemp /dev/sda | cut -d : -f3 | sed 's/[^0-9]*//g')
echo $temperature"°C"
echo "---------BATTERY---------"
monbattery
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

function monbattery {
if [ "$HAVEBATTERY" == "true" ]; then
batterylevel=$(cat /sys/class/power_supply/BAT1/capacity)
echo "Battery charge level:" $batterylevel"%"
fi
}

function lowcharge {
if [ "$batterylevel" == "20" ]; then
killall make
poweroff
fi
}

if [ "x$(id -u)" != 'x0' ]; then
    echo 'Error: this script can only be executed by root'
    exit 1
fi

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
lowcharge
done
