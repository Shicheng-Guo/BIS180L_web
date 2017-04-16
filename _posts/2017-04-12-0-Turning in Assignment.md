---
layout: post
title: How to turn in your assignments
---

I have created a github repository for each of you for this assignment.

To turn in this assignment first go to github.com and find the repository for this week.  You may need to go to the [UCDBIS180L-17 website](https://github.com/UCDBIS180L-17).  It will be something like `Assignment_1_Maloof.Julin`.  Find the clone link and clone it to your computer.

    cd
    git clone YOUR_URL
    
Then `cd` into the repos, `mv` your assignment files(s) into the repository, add, commit, and push!

    cd YOUR_GIT_REPOS
    mv Assignment_1_SA_template.md ./
    git add Assignment_1_SA_template.md
    git commit -m "added Assignment 1 documents"
    git push
    
_You will need to adjust the file paths as appropriate for your system.  Also include your Markdown lab notebooks._

For future assignments the repository for the assignment will be available as we start the lab.  I __strongly recommend that you clone the repository immediately, do your work in the repository, and commit and push as you go__.  This will provide you a backup of your work, should your AWS instance fail.