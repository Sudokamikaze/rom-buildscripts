#!/bin/bash

if [ "x$(id -u)" != 'x0' ]; then
    echo 'Error: this script can only be executed by root'
    exit 1
fi

eval $(grep HAVEBATTERY= ./config.buildscripts)
eval $(grep CRITPERCENT= ./config.buildscripts)
eval $(grep CRITTEMP= ./config.buildscripts)
eval $(grep CHECKTIME= ./config.buildscripts)

function mon {
  DATE=$(date +%H:%M:%S)
  temperature=$(hddtemp /dev/sda | cut -d : -f3 | sed 's/[^0-9]*//g')
  if [ "$HAVEBATTERY" == "true" ]; then
  chargelevel=$(cat /sys/class/power_supply/BAT0/capacity)
  fi

  case "$HAVEBATTERY" in
    true)
    if (("$temperature" >= "$CRITTEMP")); then
      logginghdd=true
      logging
    elif (("$chargelevel" <= "$CRITPERCENT")); then
      loggingbatt=true
      logging
    fi
    ;;
    *)
    if (("$temperature" >= "$CRITTEMP")); then
      logginghdd=true
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


loop=yes
while [ "$loop" = "yes" ]; do
mon
sleep $CHECKTIME
done
