---
title: "Library checkup for final"
layout: post
tags:
- R
hidden: true
---

Some people have been having trouble with their R libraries.  To make sure that everything will work for the final please check if the following will load:


```r
library(ggplot2)
library(igraph)
library(edgeR)
```

If you get an error loading any of those you have two choices.

## 1. Replace your R user libraries

* Quit R

* In Linux:

```
cd #change to your home direcoty
rm .Rhistory .Rdata
rm -r .rstudio-desktop
rm -r R # this removes your user-installed R libraries
```

* Now start R studio again

From within R


```r
install.packages("ggplot2")
install.packages("igraph")
source("http://bioconductor.org/biocLite.R")
biocLite("edgeR")
```

If that does not work, let us know.

## 2 replace the Vbox

This is a more drastic option.

A new vbox has been distributed to some of the PCs that has the required libraries.

Ask us which computers it is on.

If you want to go this route, the drag `c:\BIS180L2015` to your flash drive to replace your current vbox.  It is 14GB so it will take a while...

## Screen resize

Is your auto screen resize not working?  This means that you updated the linux kernel and need to (re)-install some vbox specific items.

You can ask us for help, but the basic procedure is:

* from the Vbox menu, go to "Devices > Insert Guest Additions CD image"

* Open up a linux terminal and:

```
cd /media/bis180lstudent/VBOXADDITIONS_4.3.26_98988/ # tab complete this, you might have a different version

sudo ./VBoxLinuxAdditions.run
```

* restart your virtual machine
