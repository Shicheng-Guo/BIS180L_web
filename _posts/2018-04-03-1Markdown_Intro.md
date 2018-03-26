---
layout: lab
title: Introduction to Markdown
hidden: true    <!-- To prevent post from being displayed as regular blog post -->
tags:
- Linux
---

[Markdown](http://en.wikipedia.org/wiki/Markdown) is a simple system for formatting text.  It is easy to type, human readable, and easy to format to html or PDF.  Almost all of the documents generated for this lab class are written in markdown.

We will require that your lab reports be generated in markdown or the variant [Rmarkdown](http://rmarkdown.rstudio.com/)

Why are we so excited about markdown?  Markdown makes it fantastically easy to generate good looking documents that adhere to __three important principles for good coding:__

1. Work should be __well documented__
2. Work should be __reproducible__
3. Files should be __saved in open__ (non-proprietary) formats

## A markdown tutorial

For an introduction to markdown, please complete [this tutorial](http://markdowntutorial.com/)

## A few extras

The tutorial covers **_almost all_** of the most important markdown features but leaves out two important ones related to code editing.  If you want to indicate a command in line with text `like this`, you should surround the text with back ticks  \`like this\`

If you want to show a block of code, then you should indent it with __4 spaces__ or 1 tab.

This will give

	for v in `ls -p /Volumes | grep BIS180L`
	do
		echo "copying to $v"
		cp -r ~/Desktop/BIS180L2015 "/Volumes/$v" &
	done

instead of

for v in `ls -p /Volumes | grep BIS180L`
do
	echo "copying to $v"
	cp -r ~/Desktop/BIS180L2015 "/Volumes/$v" &
done

## Exercise

Use the Atom editor to write a brief biography of your lab partner. 
* Open Atom by clicking on the icon on the dock at the bottom of the screen.
* You may want to close some of the "Welcome" screens.  Or explore them and then close.
* If there is not a blank document open already, type ctrl-N or select new file from the File menu
* If you want to see a Markdown Preview as you work, select Packages > Mardown Preview > Toggle

Include:

* a header/title
* his or her name
* their major (in __bold__ type)
* their year (in _italics_)
* a bulleted list of likes

Save the file and give it a `.md` extension.  You will be asked to turn it in next class.
