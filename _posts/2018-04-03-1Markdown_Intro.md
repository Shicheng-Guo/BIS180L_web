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

The tutorial covers **_almost all_** of the most important markdown features but leaves out three important ones.  

### indicating a command inline
If you want to indicate a command in line with text `like this`, you should surround the text with back ticks  \`like this\`

### code blocks
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

Alternatively, you can "fence" your code block with three backticks ``` like this:

\```
```
code goes here
```
\```

### Tables
You can make tables in markdown:

The basic format is like this:
```
| header 1 |  header 2 | header 3|
|:---------|:----------:|--------:|
| data 1.1 | data 1.2 | data 1.3      |
|  2.1 | data 2.2     |  2.3  |
```
which produces

| header 1 | header 2 | header 3|
|:---------|:--------:|---------:|
| data 1.1 | data 1.2 | data 1.3      |
|  2.1 | data 2.2     |  2.3  |

You use pipes `|` to denote the columns, and separate the headers from the data with a row of `|--|`

You can use colons in the header separating row to left or right (or center) justify.  Look at columns 1 vs 2 vs 3 in the table.  

Note that even if the spacing in your table is uneven (pipes don't line up) the table still looks good in the output.  (But try to make it like nice even in the unformatted text)

For more details, [see here](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#tables).  For tool to help you generate a table without all of that finicking typing, [see here](http://www.tablesgenerator.com/markdown_tables)

## Exercise

Use the Atom editor to write a brief biography of your lab partner. 
* Open Atom by clicking on the icon on the dock at the bottom of the screen.
* You may want to close some of the "Welcome" screens.  Or explore them and then close.
* If there is not a blank document open already, type ctrl-N or select new file from the File menu
* Save your document and give it a ".md" extenstion
* If you want to see a Markdown Preview as you work, select Packages > Mardown Preview > Toggle

Include:

* a header/title
* his or her name
* their major (in __bold__ type)
* their year (in _italics_)
* A table.  This could be of schools attended or places lived.  You would have columns for start year, end year, and location.  Or make a different table
* a bulleted list of likes
* a link that to a webpage that is relevant to something in their biography.

Save the final file.  You will be asked to turn it in next class.

**Check the markdown formatted file to make sure that it looks as you intend**