#!/bin/bash

# Define true if you on laptop
HAVEBATTERY=true
CRITPERCENT=52 # This will work if HAVEBATTERY= defined to 'true'

# Define bellow your HDD critical temperature
CRITTEMP=55

# Define bellow time check
CHECKTIME=1m

function main {
  clear
  DATE=$(date +%H:%M:%S)
  echo "Check time:" $DATE
  echo "---------Sensors---------"
  sensors | grep °C
  echo "----------HDD--------"
  temperature=$(hddtemp /dev/sda | cut -d : -f3 | sed 's/[^0-9]*//g')
  echo "Current temperature:" $temperature"°C"
  if [ "$HAVEBATTERY" == "true" ]; then
  echo "---------BATTERY---------"
  chargelevel=$(cat /sys/class/power_supply/BAT1/capacity)
  echo "Battery charge level:" $chargelevel"%"
fi
  operations
}

function operations {
  if (("$temperature" >= "$CRITTEMP")); then
  logginghdd=true
  logging
elif (("$chargelevel" <= "$CRITPERCENT")); then
  loggingbatt=true
  logging
fi
}

function logging {
if [ "$logginghdd" == "true" ]; then
echo "YOUR PC/LAPTOP HDD WAS OVERHEATED" >> CHECK_THIS_LOG.txt
echo "OVERHEAD DATE IS $DATE" >> CHECK_THIS_LOG.txt
chown $USER CHECK_THIS_LOG.txt
killall make
poweroff
elif [ "$loggingbatt" == "true" ]; then
echo "BATTERY LOWCHARGE LEVEL" >> CHECK_THIS_LOG.txt
echo "LOWCHARGE DATE IS $DATE" >> CHECK_THIS_LOG.txt
chown $USER CHECK_THIS_LOG.txt
killall make
poweroff
fi
}

if [ "x$(id -u)" != 'x0' ]; then
    echo 'Error: this script can only be executed by root'
    exit 1
fi

loop=yes
while [ "$loop" = "yes" ]
do
main
sleep $CHECKTIME
done
