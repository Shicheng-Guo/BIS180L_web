#! /bin/bash

# I can't figure out how to copy from a .dmg directly, so I mount it (in the finder) and then then use the device name.
#This has to be done manually and the script editted before running.

source=/dev/disk2s1

echo "found the following disks"

df | grep USB

disks=`df | grep USB | cut -f 1 -d " "`

for disk in $disks
do
    #echo "unmounting $disk"
    #sudo diskutil unmountDisk $disk
    echo "copying image to $disk"
    sudo asr restore --source $source --target $disk --erase --verbose --noprompt
    echo "ejecting $disk"
    sleep 2
    diskutil eject $disk
done
