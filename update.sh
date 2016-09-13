#!/bin/bash

function upsources {
  make clean && make clobber
  repo sync -j 5 -f --force-sync
}

echo "Do you want to update?: "
read item
if [ $item == y ]; then
upsources
elif [ $item == Y ]; then
upsources
else
exit
fi
