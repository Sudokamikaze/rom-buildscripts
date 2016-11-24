#!/bin/bash

# Define true if you on laptop
HAVEBATTERY=true
CRITPERCENT=40

# Define bellow your HDD critical temperature
CRITTEMP=55

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
  overheathdd=true
  logging
  echo "Overheat..."
  killall make
  poweroff
fi
}

function monbattery {
if [ "$HAVEBATTERY" == "true" ]; then
batterylevel=$(cat /sys/class/power_supply/BAT1/capacity)
echo "Battery charge level:" $batterylevel"%"
fi
}

function lowcharge {
if [ "$batterylevel" == "$CRITPERCENT" ]; then
lowchargebattery=true
logging
killall make
poweroff
fi
}

function logging {
if [ "$overheathdd" == "true" ]; then
touch CHECK_THIS_LOG.txt
echo "YOUR PC/LAPTOP HDD WAS OVERHEATED" >> CHECK_THIS_LOG.txt
echo "OVERHEAD DATE IS $DATE" > CHECK_THIS_LOG.txt
elif [ "$lowchargebattery" == "true" ]; then
echo "BATTERY LOWCHARGE LEVEL" >> CHECK_THIS_LOG.txt
echo "LOWCHARGE DATE IS $DATE" > CHECK_THIS_LOG.txt
fi
}

if [ "x$(id -u)" != 'x0' ]; then
    echo 'Error: this script can only be executed by root'
    exit 1
fi

again=yes
while [ "$again" = "yes" ]
do
DATE=$(date +%H:%M:%S)
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
