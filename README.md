# rom-buildscripts
Scripts for building/setuping/checking roms on taoshan

# Setup
Go to your topdir of ROM and clone this repo
`git clone https://github.com/Sudokamikaze/taoshan-buildscripts.git`

then read FAQ

#### FAQ

##### If u have python related problems on archlinux
then run `./setup_files.sh`
At device selection write "fixpython" not numbers

Open in your text editor `build_rom.sh` on top of the file you see TUNABLE section.

This script support only taoshan and grouper, if u want to build for grouper or taoshan
open `build_rom.sh` and edit DEVICE section
