---
layout: lab
title: Instructions on installing and using the BIS180L virtual linux machine
hidden: true    <!-- To prevent post from being displayed as regular blog post -->
tags:
- Linux
---

## About
Most bioinformatics software runs on linux or unix (including Mac) computers.  For this class we will work in a linux environment.  Since the computer labs have Windows machines we will run linux in a virtual environment.

Specifically we will run a program called [VirtualBox](https://www.virtualbox.org/) on the Windows machine ([more info](http://en.wikipedia.org/wiki/VirtualBox)).  Virtualbox creates a virtual machine, hosted on the Windows PC, which will run linux.

Because files on the computer lab PCs get wiped every day we need a way to preserve what you are working on.  To do this we have configured the virtual machine to use your flash drive as your home directory.  The flash drive needs to be formatted and named in a precise way so please use the one that you are given in class.  This way files that you save can be used from class to class.

It also will be possible to run the BIS180L virtual machine on your personal computer; we will explain how to do that in a future post.

If you are curious about what version of linux we are using, and what programs I installed, please see the [this document]{% post_url 2016-03-29-Creating_BIS180L_virtual_machine %}.


## Get your home directory flash drive

The instructor or TA will give you a USB flash drive formatted with a home directory

## Starting the virtual machine

1. On the PC go to Computer > Local Disk (C:) > BIS180L2016 ![BIS180L vbox ](){{ site.baseurl}}/images/Start_Vbox.png)
2. Double click on the file "BIS180L2016.vbox".  This will open Virtual box
3. Once Virtual Box opens you may need to double click on "BIS180L2016" to start the virtual machine or it may start directly.
4. Insert the USB flash drive __into one of the righthand USB ports__.  It is important to use the right hand ports because they are USB 3.0 and much faster.  __Do not__ insert the flash drive before starting the virtual machine.
5. You should now have a window that looks like this: ![BIS180L linux desktop]({{ site.baseurl }}/images/Logon.png)

6. login using the information below

## Username and Password

The username and password are:

username: `bis180lstudent`

password: `bioinformatics`

You should now have the linux desktop  ![BIS180L linux desktop]({{ site.baseurl }}/images/BIS180L_screenshot.png)

## Warnings

If you get a window "Update information" "Failure to download extra data files" you can click on close.

__Very Important: DO NOT RUN THE SOFTWARE UPDATER__ (If you do the Virtual Box integration will not work well.  If you do run it by mistake let Prof. Maloof know and he will show you how to fix it)

## Using the machine.

You can resize the "screen" by dragging from the lower-right corner.

You should be able to cut and paste between your host machine and the virtual machine.  Mac users note that inside the virtual machine you will need to use ctrl-C, not CMD-c, etc.  Also the cut and paste commands for the terminal are shift-ctrl-C and shift-ctrl-V.

The icons at the bottom left give you access to various programs.  

From left to right:

* Start menu.  This gives you access to system preferences and a variety of programs.
* File manager.  Equivalent to the Mac "Finder" or Windows "Explorer"
* LXTerminal.  Provides access to the Linux command line
* Firefox Web Browser
* [Atom](https://atom.io/).  A text editor with good features for programming.
* [Rstudio](http://www.rstudio.com).  An IDE (Integrated Development Environment) for [R](http://www.r-project.org)
* [Gnumeric](http://www.gnumeric.org).  A spreadsheet application
* [Remarkable.](http://remarkableapp.net)  A text editor for working in [Markdown](http://en.wikipedia.org/wiki/Markdown)
* This button will collapse windows
* This button allows you to switch desktops

## Create a MEGA account

It is critical that you **keep a backup of your files** (both for this class and always).  For this class we will accomplish backups by syncing with the cloud storage provider [MEGA](https://mega.co.nz)

* Click on  `Start > Internet > MEGAsync`
* Register for a new account or logon to your existing account (if you have one)
* Check your email and click on the link to complete registration
* Choose `Selective Sync`
	![SelectiveSync]({{ site.baseurl }}/images/SelectiveSync.png)
* Click on the buttons and change folders to be synced to:
	* Local Folder: `/home/bis180lstudent`
	* MEGA Folder: `/BIS180L` (you will have to create a new folder)
	![MEGAfolders]({{ site.baseurl }}/images/MEGAfolders.png)
* If successful you should get a message indicating that MEGAsync is now running.

## Logging out

1. Click on the power icon (bottom right) and choose shutdown ![LogOff]({{ site.baseurl}}/images/BIS180L_logoff.png)
2. After virtual box quits click to eject the USB drive (lower right, with a check mark)

# Extras not needed for lab


## Extra: Install VirtualBox at home

If you want to do this at home you need to install VirtualBox.  It is free.

Download and install [VirtualBox](https://www.virtualbox.org/)

Direct link to [download page.](https://www.virtualbox.org/wiki/Downloads)  The extension pack is optional.

The virtual machine is formatted to use 3 cores and 3GB of memory.  You may need to change this depending on the specifications of your (real) computer.  See "Settings" in virtual box.

## Get the Machine Image for home

You can download the machine image [here](http://malooflab.phytonetworks.org/downloads/BIS180L/BIS180L2016_v2.zip)
