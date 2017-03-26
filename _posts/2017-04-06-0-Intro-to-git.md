---
layout: lab
title: Introduction to git
hidden: true   
tags:
- Git
---

## Reading

For an overview of how Git can be used in the biological sciences, please read this excellent [article by Ram](http://www.scfbm.org/content/8/1/7).

For a practical introduction please read Chapter 5 in [Bioinformatics Data Skills](http://shop.oreilly.com/product/0636920030157.do) available from the library [here](https://harvest.lib.ucdavis.edu/F/CYUA711QE89QJB4FHK5GTGIKTQ7LLXY31UL9LXU2XUR7QUHXEH-06773?func=full-set-set&set_number=076035&set_entry=000002&format=999&local_base=ucd01pub)

## Git: reproducibility and collaboration

This document will introduce you to __Git__, a version control system that is a great aid in writing software, maintaining documentation, and maintaining reproducibility.

What does Git do?  Git keeps track of changes that you (and your collaborators) make in your documents.  By maintaining a record of all the changes that have been made you can restore your project to an earlier state if needed (i.e. if you screw up).  Git also allows you to maintain different versions (known as branches in Git) simultaneously, an incredibly useful feature.  For example you can maintain a "master" branch that works correctly.  You try out changes in a "develop" branch without breaking the working "master" version.  Once you know that your changes in "develop" are functioning as intended you can merge them into the "master".

## A few key concepts

A project that is tracked by Git is called a __repository__ (repo for short).

To start a new repository you use the `git init` command.

To add files for git to track you use `git add`.

When you have made some changes to your project and you want to __commit__ those changes to the repository you use `git commit` typically with the option `-m` to include a brief message about the changes made.

If you are collaborating with others, or just want to share your project, you will want to set up a __remote repository__.  One common (and free!) hosting site is [GitHub](https://github.com/).  When you want to add your changes to the remote repository you __push__ to the repository using `git push`.  When you want to download changes that others have made then you want to __pull__ changes using `git pull`.

## Learn about git using an online tutorial

Now let's see some of this in action.

To learn how to create and interact with a repository, please do [this tutorial](https://try.github.io/levels/1/challenges/1)

Keep track of what each command that you learn does by making notes for yourself in a markdown document (perhaps gitNotes.md)

## Now let's try it in real life.

First get a [GitHub](https://github.com/) account

### Make a repository and collaborate

Work in a group of 2 or 3 people. Each partner should follow along with what the others are doing so you are versed in all steps.

Designate one of you to create a new repository.  This is Partner 1.

There are two ways to make a new repository and get the local and remote versions linked.  Either you create it on Github first and clone it down to your computer or you init it on your computer and link it to a Github repository.  Details are below:

1) Create the repository on Github first.

1. From your github.com home page click on the green "+ New Repository" button (right hand side of screen)
2. On the resulting page give it a name, check the "Initialize this repository with a  README" box and press the "Create Repository" button.
3. Click on the clipboard icon to copy the URL
4. Open the terminal on your computer, `cd` to the parent directory of wherever you want the repository to reside and then `git clone URL` where URL is the URL that you copied from Github.
5. You can now `cd` to your repository and begin working on it.

__OR__

2) Create the repository on your computer first.

1. `cd` to the parent directory of where you want the repository to reside.
2. `mkdir NAME` where NAME is the name you want for your repository.
3. `cd NAME` to move into the repository
4. `git init` to initialize a repository in the current directory
5. Add a file to the repository.  For example:  

	`touch README.md`  
	`git add README.md`  
	`git commit -m "Added README.md"`  


6. Go to Github.com
7. From your github.com home page click on the green "+ New Repository" button (right hand side of screen)
8. On the resulting page give it a name and press the "Create Repository" button.  __DO NOT__ check the "Initialize this repository with a README" box.
9. Click on the clipboard icon to copy the URL next to the heading __"…or push an existing repository from the command line"__
10. Paste that into the terminal while in the directory of your repository.  i.e.   

	`git remote add origin git@github.com:jnmaloof/test2.git`  
	`git push -u origin master`  

### Now lets try it

* Partner 1:
	* Add a file to the repository with a bit of text (what your plans are for the weekend?).  
	* Commit your change
	* Push the repository to git hub
	* Go to the github website for this repository.
	* Add  Partner2 as a collaborator.

* Partner 2 (and 3):
	* Clone the repository to your computer
	* Add your information (what your plans are for the weekend?)
	* Commit your change
	* Push the changes to the repository
	* Run git log and save the output to a file.

* Partner 1:
	* Pull the changes back to your computer
	* Run git log and save the output to a file.

* Want a graphical view of what is going on?
	* type `gitk` at the command line when you are in the directory of a git repository.

### Fork a project

The above exercise illustrate one way to collaborate: each collaborator is added as a contributor to the repository.  A second (and perhaps more common) method is to __fork__ a repository.  When you fork a repository your are creating your own copy of the repository.  You then make changes to your fork.  If you think the original creator might want to incorporate your changes than you can create a __pull request__ to request that they pull your changes back into their repository.  This is safer for the original creator because it is easier for them to choose to include your changes if they don't like them.

Let's try it.  I need to collect everyone's GitHub usernames.  To do this we will each add a file to a shared repository with our details.  I have created a repository [https://github.com/UCDBIS180L/gh-usernames](https://github.com/UCDBIS180L/gh-usernames) for this purpose.

* Go the home page for that repository in your web browser.
* Fork it using the button on the upper right hand side.
* Clone your forked repository to your computer
* Open the file "2016_roster.csv" in `nano` or `atom`
* Find your name in the file and add your github user name after the last comma (look at my entry for an example).  (If you can't find your name, add a new entry at the _bottom_ of the file.)
* Save your changes the file.
* Add and commit your changes.
* Push your change back up to your repository.
* Use the website to send a pull request.

## More resources

Still confused?  Or want to go further?  Here are some additional resources

### Tutorial

An alternative tutorial

[GitHub for beginners Part 1](http://readwrite.com/2013/09/30/understanding-github-a-journey-for-beginners-part-1)
[GitHub for beginners Part 2](http://readwrite.com/2013/10/02/github-for-beginners-part-2)

### Videos

The four part git basics series (the first two were shown in class)

1. https://www.youtube.com/watch?v=8oRjP8yj2Wo
2. https://www.youtube.com/watch?v=uhtzxPU7Bz0
3. https://www.youtube.com/watch?v=wmnSyrRBKTw
4. https://www.youtube.com/watch?v=7w5Z7LmyLgI

[A longer video](https://www.youtube.com/watch?v=U8GBXvdmHT4) (50 minutes)

[GitHub Video Channel](https://www.youtube.com/user/GitHubGuides/videos)

### Online book

The official online [git manual](http://git-scm.com/book/en/v2)
