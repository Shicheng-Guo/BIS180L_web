---
layout: post
title: Creating git repositories and linking them to Github
---
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
