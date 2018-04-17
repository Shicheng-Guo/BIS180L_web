---
layout: page
title: FAQ
---

# Week one and two[](#week-one-and-two)
Q1
=============
_How do I do a for loop in fish where I designate a number instead of it going through all the contents of a file? [group: type an example in your terminal and then I will display your screen]_

This was discussed in class.  I am not entirely sure what is being asked here but:

```
for num in 1 2 3 4 5
    echo $num #print the current number to the screen
    touch file$num.txt #creates a file with the current number in the name
    end
    
ls # see what we have done
```

Q2
=============
_I am still unsure of how to eliminate new line space from the character count of genome/proteome files._

Discussed in class.  

Laurel and Melodie came up with this:
```
grep -v ">" protein.fa | tr -d \n | wc -c
```

Great solution.  I was doing something less elegant: using `wc` to give me both a character and a line count.  Then manually subtracting the line count from the character count.

Q3
=============
_Im still a little confused about what the "grep" command is, and when it should be used. Can you clarify the function of this command?_

`grep` searches for something in a file and returns lines that have a match.  Options to return lines that don't match, to count the number of lines that match, to return lines before or after the match, etc.

See `man grep`

Q4
=============
_Why are the scores for aligning B0213.10 with the best-matching A.thaliana and D.melanogaster proteins so high, yet the % identities so low?_

Discussed in class.  1) because similar amino acids can still have a positive score; 2) If you look at a scoring matrix general the matches are more positive than the mismatches are negative; 3) 35% identity really probably does mean shared ancestory.

Q5
=============
_Could you please explain more about statistical significance and biological relevance. In case if your data is statistically significant but biologically not that relevant, how do you handle it?_

Discussed in class.  Basically it is your decision as a researcher what is likely to be biologically significant.  Just be sure to explain your reasononing.

Q6
============
_If we shuffle enough more times of a sequence, would the alignment of a protein with it will be normally distributed? or still skewed?_

Discussed in class.  1) Try it!  2) Still skewed.  Why?  Skewing results from the fact that this is a local alignment and that *some* aligment will be found and reported.  Anti-alginments are not reported.  Skew also may result from composition similarities between the sequences.  (Think about if both sequences were 50% S but unrelated).

Q7
=============
_If the distribution of the alignment score is not normal, how could we use z-score and determine the E-value?_

Although skewed the distributsion is still unimodal so the Z-score is still informative about how many SDs away from the mean you sequence is. 

You can then determine what percentage of your random sequences had at least that large of a Z-score.  So if your Z-score is 2.5 and only 3% of your random sequences have a Z-score > 2.5, then your E-value is ~ 3%. (Although you could also just do this directly with the alignment score).

Q8
==========
_Many questions about calculating speed of alignment_

My recommended pipeline:

* Align one protein sequence (query) against proteome#1 and time it.
* Divide that time by the the number of amino acids in your query to give seconds/amino acids when aligning to proteome#1
* Determine the number of amino acids in proteome#2
* Multiple your rate (sec/aa) * number of amino acids in proteome#2

Q9
=============
_What exactly is an alias?_

It is a pointer to the files true location

Q10
===============
_When doing BLAST, how do we decide what parameters to use when comparing two sequences?_

Decide on your goals and priorties:

* Sensitivity?
* Speed?
* Only closely related matches?
* Distant matches?

There is no one right answer, it is tradeoffs

Q11
========
_Is there a limit to the number of pipelines one can create in a single command?_

Not that I am aware of.  Readibility becomes limiting.

Q12
======
_How to researchers determine what is a good cutoff at which point to consider two sequences homologous? It all seems kinda arbitrary from the assignment._

E-values and match length.  I like to see that the alignment stretches across most (75%?) of the protein that I am looking at, even if it is a low percentage.  If I have a good match but only for 30% of the protein that might indicate a homologous domain but not the whole protein.

Q13
========
_Is there a way to visually see the overlap/comparison between two genomes/proteomes? Say like in a venn diagram?_

Should be easy to do in R, maybe I will include this when we move to R


Q14
=======
_Is there a particular programming language languages that are the best to know for programming in Bioinformatics?_

R and Python, plus at leat a bit of Linux shell

Q15
======
_Why do the 2 spaces after a line that separates the lines in markdown disappear when I save the file?_

Sorry.  I thought I fixed this but I didn't.

In Atom: Edit > Preferences > Packages.  Then search for "whitespace" and click disable

![](whitespace.png)

Also, should be fixed in new installations of Atom.

Q16
========
_this is my first time learning how to use GitHub - So I‚am a bit confused and was wondering how do we see our work as a site (like_

Go to [](https://github.com/orgs/UCDBIS180L-18/) and then click on your repository.  You should be able to click on a filename and then see it in your web browser.

Q17
=====
_"Can you talk more about awk?"_

Powerful but cryptic text processing language.  There are books about it.  Probably better off learning Python.

Q18
=======
_What is the difference between our t2 medium and t2 large instances, and in what situation would¬† we use one instead of the other?_

t2.medium has 4GB RAM and t2.large has 8GB.  If we are doing a memory intensive task then we will switch to large.

Q19
=======
_How does the type of scoring matrix used affect the run time?_

A scoring matrix designed for more distantly related sequences will not penalize mismatches as much.  Thus there will be more initial matches and runtime will be longer.

Q20
=========
_I chose a threshold of 150 but wanted to know what is considered statistically significant and acceptable for proteome comparisons._

There is not one proper answer here.  It would depend if you are interested in only close matches or in more distant matches.  150 is too high to find distant matches.

Q21
=========
_How do you calculate the number of bp in the genome in all one step?_

See Q2

Q22
======
_Can you find the Z-score using the command line?_

Yes, although not too easy.  You can google "awk standard deviation" to see how that would work.  And then use the command line calculator `bc`

Q23
=======
_After ""pushing"" Assignment 1 onto github, I noticed that for the markdown chart I made for question 2 is formatted incorrectly, yet in the ""toggle preview"" on Atom the chart was fine._

The number of separators in the header (first line of the table), separator ("|:---|:--------|:--------|:-------------|"), and he rest of the table needs to match.  In your case it doesn't.

Q24
========
_What exactly is linux/unix (ie. a processor, a language, a computer program?)_

An operating system.  If you run a Windows PC there is an operating system that displays windows, manages files, etc.  Linux or Unix are alternative operating systems.

The operating system is still a progrom (or a series of programs).  But they are the "core" programgs.

Q25
=====
_I'm still not sure what tar balls are and when I would use them. Would using a tar ball have been appropriate/faster when setting up the file structure at the beginning of the first lab?_

A way of archiving and compressing a set of files and directories into a single file.  So they are useful for sharing a set of files with others.  You would still need to set up the directory and file structure first so I don't see that it would have helped for the first lab.  (Although if I had created one for you then you could have downloaded and unpacked it and been all set).

Q26
=====
_Are assignments supposed to be markdown format? We we are supposed to "paste" code is there anything special we are supposed to do in that case?_

Yes, they are supposed to be in markdown format.  When including code you need to use proper markdown so that it is formatted as a code blocks.  This is explained in the markdown lab.

Q27
=====
_How do you determine the default parameters for water and BLAST? I can't seem to find it in the -help command._

For water `man water`.  For BLAST, some are shown using `blastp -help` but not all.  For the others run a blast and then look at the end of the output file.

Q28
=====
_In for loop, sometimes we say echo {$x} and sometimes we say echo "$x". What is the difference?_

including the "{}" makes it more clear to the shell where the variable is.  This would important if you had the variable $x and $xylophone.

```
set x foo
set xylophone bar
echo $x
echo $xylophone
echo {$x}ylophone
```

Q29
=========
_is there a way to log all the terminal activity automatically and store it somewhere so I can be lazy and not copy/paste all the commands I typed in a given session?_

```
history
```

Q30
========
_Does BLOSUM matrix with a higher percent identity gives a lower score with the same data? Or not? Why is that?_

1) Look at the different matrices and make a hypothesis.  2) Test it.



