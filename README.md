# taoshan-buildscripts
Scripts for building/setuping/checking roms on taoshan

# Setup
Go to your topdir of ROM and clone this repo
`git clone https://github.com/Sudokamikaze/taoshan-buildscripts.git`

then read FAQ

#### FAQ

Open in your text editor `build_taoshan.sh` on top of the file you see TUNABLE section.

`# ==================TUNABLE==================`

`export BLOCK_BASED_OTA=false # Remove this if you don't want to disable BLOCK Based SHIT!`

`CACHEDIRPATH=/ccache/RR/ # Define your dir for ccache here`

`CCACHESIZE=10 # Define size of cache in GB`

`IFARCHLINUX=true # Define true if your distro IS ArchLinux/ Define false if your distro NOT ArchLinux`

`# ===========================================`


Write your values to this variables
