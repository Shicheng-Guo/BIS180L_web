---
layout: lab
title: Fish and Bash for loops
hidden: true    <!-- To prevent post from being displayed as regular blog post -->
tags:
- Linux
- sequence
---

## Clone the assignment two repository

__Answers to the first two exercises will be turned in as part of Assignment 2 (See BLAST lab)__

I have created a repository for this lab and the BLAST lab, to be turned in together.  To get started, clone the repository now.  You can find the appropriate URL by going to github.  

	cd 
	git clone YOUR_URL
	cd Assignment_2_XXXXXX.XXXXXX
	touch lab2_notebook.md
	git add lab2_notebook.md

Keep a list of your the commands that you used in your lab2_notebook.md file. 

## Background

I have claimed that there are tools at the command line that make automating tasks easier. You are probably wondering when you will get to see that.  Now is the time.

For the sequence alignment task you were asked to run the random alignments against three different scoring matrices and two different gap extend penalties.  This means that you needed to type almost the same command six times.  Tedious, right?  What if there were 100 scoring matricies?  Then it would get super tedious.

What we want is a method to automatically run the command with the variations that we care about.  To do this we want a __for loop__

## Fish and Bash

In this class we are using the _fish_ shell.  Most flavors of Linux and unix would default you into using the _bash_ shell.  The syntax for the following is a bit different.  I will present the _fish_ version first.  I'll also include the _bash_ versions further along on this page, in case you need them at some other time.  

# FISH version

## For Loops

A __for loop__ is a method of iterating over a series of values and performing an operation on each value.  All programming languages have some version of this, although the syntax varies.

First a toy example.  Lets say that we have a list of fruit and we want to convert the fruit names to plurals.

First lets create our items.  (Type these commands yourself to get practice)

    set fruits banana apple orange grape plum pear durian pineapple

This creates the variable `fruits` and fills it with the list of fruits.

Remember to refer to a variable after it is defined we place a "$" in front of it

    echo "$fruits"

In unix-fish a for loop has three parts
1. A `for` statement saying what items we want to loop over
2. The commands to repeat
3. `end` to indicate the end of the loop

So if we want to loop through each fruit in $fruits and print them one at a time we would write

    for fruit in $fruits 
        echo "$fruit"
    end

Translation: for each fruit in the list of fruits `$fruits` take one value at a time and place it in a new variable `$fruit`.  Then run the command `echo $fruit` is run to print the current fruit.  Go back to the top, place the next fruit in the list into $fruit and repeat the `echo` command.  This will continue until there are no more fruits.

What if we want to add an "s" to make these fruit plural? 

    for fruit in $fruits 
        echo {$fruit}s
    end

The curly brackets are used to help bash distinguish between the variable name `fruit` and the text we want to add `s`

__Exercise One__: Write a for loop to pluralize peach, tomato, potato (remember that these end in "es" when plural)

## interacting with files.

We can also use file names as input or output in for loops.  Here is another silly example, but hopefully it illustrates the point.  Let's say the goal was to print the output of every file in a directory.

First set it up:

    mkdir for_example
    cd for_example
    echo "this" > file1.txt
    echo "is" > file2.txt
    echo "silly" > file3.txt
    
Now to use these files in a for loop:

    set myfiles (ls)
                     
    echo $myfiles         # make sure it really does have a list of files
    
    for file in $myfiles
        cat $file
    end
    
What are the parentheses doing with the ls command in `set myfiles (ls)`??  by enclosing "ls" in parentheses we tell fish to run the ls command and place the results in the variable "myfiles"
                 
__Exercise Two__ In your own words provide a "translation" of the above loop.

Note that we could be more shorthand about this and not bother defining `$myfiles`

    for file in (ls)
        cat $file
    end

__Exercise Three__ Modify the above loop to produce the following output

> file file1.txt contains: this
> file file2.txt contains: is
> file file3.txt contains: silly

_hint 1_ you will want the command inside the loop to start with `echo`
_hint 2_ you will need to enclose something in parentheses

If you want a bit more of a challenge, try this (optional)

> file "file1.txt" contains: "this"
> file "file2.txt" contains: "is"
> file "file3.txt" contains: "silly"

_hint_ click [here](http://fishshell.com/docs/current/index.html#syntax) and scroll down to "Quotes" and then "Escaping Characters"

You can also the for loop to create new files, i.e.

    set newFiles one two three four
    echo $newFiles
    
    for f in $newFiles
        touch {$f}.txt
    end
    
    ls

__Optional Exercise Four__: Write a for loop that runs the `water` command from the Sequence Alignment lab three times, (once per loop) each time using a different scoring matrix.  Be sure that the results from each call to `water` is saved in a different file with the file name indicating the parameters that were used.

## Nested for Loops

In our case, for each type of scoring matrix we want to use two different gap extension penalties.  Can we automate this also?  Yes!  We could just write two for loops, or include two calls to `water` in our single for loop.  But what if we wanted to go through 10 different gap extension penalties?  In this case we could use a __nested for loop__

### fruit example

For some reason we want to add the numbers 1 to 10 after each of our fruit names...

    set fruits banana apple orange grape plum pear durian pineapple

    for fruit in $fruits 
        for number in 1 2 3 4 5 6 7 8 9 10
            echo $fruit $number
        end #ending the inside loop
    end #ending the outside loop

For each fruit we now loop through each of the numbers...

__Optional Exercise Five:__ Use a nested for loop to run water for each scoring matrix and gap extension penalties from 3 through 9


# BASH version

__OPTIONAL: BIS180L Students do not need to do this__

This is here as a reference in case you are working in the Bash shell

## For Loops

A __for loop__ is a method of iterating over a series of values and performing an operation on each value.  All programming languages have some version of this, although the syntax varies.

First a toy example.  Lets say that we have a list of fruit and we want to convert the fruit names to plurals.

First lets create our items.  (Type these commands yourself to get practice)

    fruits="bannana apple orange grape plum pear durian pineapple"

This creates the variable `fruits`

Remember to refer to a variable after it is defined we place a "$" in front of it

    echo "$fruits"

In unix-bash a for loop has four parts
1. A statement saying what items we want to loop over
2. `do` to note the beginning of the commands that we want to loop through
3. The commands to repeat
4. `done` to indicate the end of the loop

So if we want to loop through each fruit in $fruits and print them one at a time we would write

    for fruit in $fruits 
    do
        echo "$fruit"
    done

For each fruit in $fruits the value is place in a new variable $fruit.  The command `echo $fruit` is run, and then the next fruit is place in $fruit and the `echo` command is repeated.

What if we want to add an "s" to make these fruit plural? 

    for fruit in $fruits 
    do
        echo "${fruit}s"
    done

The curly brackets are used to help bash distinguish between the variable name `fruit` and the text we want to add `s`

__Exercise One__: Write a for loop to plurlalize peach, tomato, potato (remember that these end in "es" when plural)

Confused?  There are a bunch of tutorials online.  I like [this one](http://www.cyberciti.biz/faq/bash-for-loop/) and [this one](http://www.tutorialspoint.com/unix/for-loop.htm)

__Exercise Two__: Write a for loop that runs the `water` command three times, (once per loop) each time using a different scoring matrix.  Be sure that the results from each call to `water` is saved in a different file with the file name indicating the parameters that were used.

## Nested for Loops

In our case, for each type of scoring matrix we want to use two different gap extension penalties.  Can we automate this also?  Yes!  We could just write two for loops, or include two calls to `water` in our single for loop.  But what if we wanted to go through 10 different gap extension penalties?  In this case we could use a __nested for loop__

### fruit example

For some reason we want to add the numbers 1 to 10 after each of our fruit names...

    fruits="banana apple orange grape plum pear durian pineapple"

    for fruit in $fruits 
    do
        for number in 1 2 3 4 5 6 7 8 9 10
        do
            echo "$fruit $number"
        done
    done

For each fruit we now loop through each of the numbers...

__Exercise Three:__ Use a nested for loop to run water for each scoring matrix and gap extension penalties from 3 through 9


















