---
layout: post
title: git and MEGA
---
You will remember in class today that some students had trouble with their git repositories.

The reason is that git stores all of the information in a hidden directory `.git` at the top level of the repository.

And MEGA, by default, does not sync hidden files or directories.

So if your repository was just downloaded by MEGA then it won't have the git information.

To prevent this from happening in the future:

Tell MEGA to sync the hidden files.  Click on the MEGA symbol at the bottom right side of your (virtual) desktop.  Click on the gear icon (upper right) and then on settings.  Choose the advanced tab (1 in figure below) and then select the ".*" line (2) and click on delete (3).  

![]({{ site.baseurl }}/images/MEGA_git_example.png)

