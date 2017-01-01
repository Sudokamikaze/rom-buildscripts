# rom-buildscripts
Scripts for building/setuping/checking roms on taoshan

# Setup
Go to your topdir of ROM and clone this repo
`git clone https://github.com/Sudokamikaze/taoshan-buildscripts.git`

then read FAQ

#### FAQ

Before you start work look in config.buildscripts, all settings in this config

Setting | Description
-------:|:-------------------------
IFARCHLINUX=  | This var trigger python venv activation&creating
BUILDKITKAT=  | This option is defined by default to auto
CCACHEENABLE= | CCACHE activation
CCACHESIZE=   | CCACHE size
CACHEMAINPATH=| Main CCACHE Path
CACHERESERVEPATH=| Reserved CCACHE Path(for multi-device building)
BLOCK_BASED_OTA=| This option called by build_rom and this disable block based,leave it to false
CURRENTDEVICE= | Current device
HAVEBATTERY=| mon_all.sh will display current battery charge level
CRITPERCENT=| When charge level reach this value laptop will shutdown
CRITTEMP=| Critical temperature for HDD(if script reach this value PC will shutdown)
CHECKTIME=| How often script check temperature and charge level


This script support only taoshan and grouper if you want you can modify manifests and look in build_rom.sh source and modify it might work


if you want to switch build device open `config.buildscripts` and edit DEVICE section or run `./device_switcher.sh`

##### If u have python related problems on archlinux
then run `./setup_files.sh`
At device selection write "fixpython" not numbers
