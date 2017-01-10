#!/bin/bash

set -e

eval $(grep HAVEBATTERY= ./config.buildscripts)
eval $(grep CRITPERCENT= ./config.buildscripts)
eval $(grep CRITTEMP= ./config.buildscripts)
eval $(grep CHECKTIME= ./config.buildscripts)

chUSER=$(users | awk {'print $1'})

function main {
  temperature=$(hddtemp /dev/sda | cut -d : -f3 | sed 's/[^0-9]*//g')
  chargelevel=$(cat /sys/class/power_supply/BAT1/capacity)
  if [ "$quiet" == "true" ]; then
  operations
else
  clear
  DATE=$(date +%H:%M:%S)
  echo "Check time:" $DATE
  echo "---------Sensors---------"
  sensors | grep °C
  echo "----------HDD--------"
  echo "Current temperature:" $temperature"°C"
  if [ "$HAVEBATTERY" == "true" ]; then
  echo "---------BATTERY---------"
  echo "Battery charge level:" $chargelevel"%"
fi
  operations
fi
}

function operations {
  case "$HAVEBATTERY" in
  false)
  if (("$temperature" >= "$CRITTEMP")); then
  logginghdd=true
  logging
fi
  ;;
  true)
  if (("$temperature" >= "$CRITTEMP")); then
  logginghdd=true
  logging
elif (("$chargelevel" <= "$CRITPERCENT")); then
  loggingbatt=true
  logging
fi
  ;;
esac
}

function logging {
if [ "$logginghdd" == "true" ]; then
echo "YOUR PC/LAPTOP HDD WAS OVERHEATED" >> CHECK_THIS_LOG.txt
echo "OVERHEAD DATE IS $DATE" >> CHECK_THIS_LOG.txt
chmod $chUSER CHECK_THIS_LOG.txt
killall make
poweroff
elif [ "$loggingbatt" == "true" ]; then
echo "BATTERY LOWCHARGE LEVEL" >> CHECK_THIS_LOG.txt
echo "LOWCHARGE DATE IS $DATE" >> CHECK_THIS_LOG.txt
chmod $chUSER CHECK_THIS_LOG.txt
killall make
poweroff
fi
}

if [ "x$(id -u)" != 'x0' ]; then
    echo 'Error: this script can only be executed by root'
    exit 1
fi

while getopts ":q" opt ;
do
  case $opt in
    q) echo "mon_all.sh started in quiet mode"
    quiet=true
    ;;
esac
loop=yes
while [ "$loop" = "yes" ]
do
main
sleep $CHECKTIME
done
done
