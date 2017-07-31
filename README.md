# rom-buildscripts
Scripts for building firmware for any device

# Install
Execute this command at top dir

`wget https://raw.githubusercontent.com/Sudokamikaze/rom-buildscripts/master/install_me.sh -O - | bash `

then read FAQ

#### FAQ

Before you start work look in config.buildscripts, all settings in this config

Setting | Description
-------:|:-------------------------
IFARCHLINUX=  | Triger for python2 virtualvenv creation
HASTE=        | Sends log file and status of build to yo in telegram
romname=      | Name of your rom
CCACHEENABLE= | Do you need CCACHE for yo building?
CCACHESIZE=   | Size
CCACHEPATH=   | Path
ROOT=         | Some firmwares like LineageOS require this
MON=          | Enabling monitoring of temperature in background
CURRENTDEVICE=| Your device name, e.x mako
HAVEBATTERY=| Triger for battery level monitoring
CRITPERCENT=| When yo battery reach this level, laptop will poweroff
CRITTEMP=| Critical temperature for HDD also PC shutdown if reach it
CHECKTIME=| Checking time, leave it to default or decrease to 1 minute

