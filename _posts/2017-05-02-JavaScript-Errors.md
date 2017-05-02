---
title: "Java Errors in R Studio"
layout: post
tags:
hidden: 
---

If you are getting on of the following error message when opening R Studio

![]({{site.baseurl}}/images/Java_Error.png)


### 1. Close your R session and open a new R session

If your R session will not close use Htop to find the PID number for that instance and kill it. 

![]({{site.baseurl}}/images/Htop.png)

From a terminal window:

    Htop
    Kill 1425

### 2. If the problem still persist reset the R Studio desktop state

When you run your R Studio diagnostics you should see lots of Error
messages at the end of the file.

From a terminal window:

    rstudio --run-diagnostics
    tail ~/rstudio-diagnostics/diagnostics-report.txt

Reset R by moving your Rdesktop info, then re-run the diagnostics

    mv ~/.rstudio-desktop ~/backup-rstudio-desktop

