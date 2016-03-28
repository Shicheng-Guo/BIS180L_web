#! /bin/bash

disks=`df | grep USB | cut -f 1 -d " "`

for disk in $disks
do
    echo "unmounting $disk"
    diskutil unmountDisk $disk
    echo "copying image to $disk"
    sudo dd if=/Users/jmaloof/Desktop/BIS180L2016_home.dmg of=$disk bs=1m
    echo "ejecting $disk"
    diskutil eject $disk
done
