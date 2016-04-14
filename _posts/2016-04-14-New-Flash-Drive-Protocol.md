---
layout: post
title: New Flash Drive Protocol
---

Here is a new, improved method for being able to preserve changes to your home folder and use it on multiple computers.

In our configuration Virtual Box saves changes to its virtual hard drive in a snapshot folder.  In our case the changes are saved in a file called `{d393e90d-5c61-4066-a7fe-7c2d262e723e}.vdi`

We can use this to save our work and avoid the problems of using the flash drive to host our home directory.  The file can be saved either on your flash drive (it should work much better than when we used it to host the home directory directly).

## To save your work / home directory for use another day

1. Be sure that you are using the BIS180L_local account.
2. When you are done for the day, log off of the virtual machine and quit VirtualBox.
3. Open a File Explorer window on the PC and go to `Computer\Local Disk (C:)\BIS180L\Snapshots`.
4. There will be two .vdi files.  You want the one with today's modification date and the name `{d393e90d-5c61-4066-a7fe-7c2d262e723e}.vdi`.  Drag this file to your flash drive or upload to GoogleDrive, etc.

![Snapshot1]({{ site.baseurl }}/images/Snapshot1.png)

Warning: The file will get large so GoogleDrive may be slow.  On the other hand, the cloud backup is always nice.  I would do both until the file gets too large for GoogleDrive to practical.

## To restore your work

1. Be sure that VirtualBox is not running.
2. Copy the `{d393e90d-5c61-4066-a7fe-7c2d262e723e}.vdi` file from your flash drive or GoogleDrive to `Computer\Local Disk (C:)\BIS180L\Snapshots`.
3. Windows will ask you what you want to do since there already is a file with that name.  Choose `Copy and Replace`
4. Start VirtualBox in the normal way.
5. Be sure to follow the direction above on how to save your work when you are done.

![Copy And Replace]({{ site.baseurl }}/images/Snapshot2.png)
