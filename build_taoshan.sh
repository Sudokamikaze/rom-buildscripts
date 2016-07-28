#!/bin/bash
# ==================TUNABLE==================
export BLOCK_BASED_OTA=false # Remove this string if you don't want to disable BLOCK Baseds SHIT!
CACHEDIRPATH=/ccache/RR/ # Define your dir for ccache here
CCACHESIZE=10 # Define size of cache in GB
# ===========================================

# PREPARE STAGE
. build/envsetup.sh
virtualenv2 venv
ln -s /usr/lib/python2.7/* /home/kitt/Git/tmp/RR/venv/lib/python2.7/
source venv/bin/activate
export USE_CCACHE=1
export CCACHE_DIR="$CACHEDIRPATH".ccache
prebuilts/misc/linux-x86/ccache/ccache -M "$CCACHESIZE"G

# BUILD STAGE
croot
. build/envsetup.sh && brunch taoshan
