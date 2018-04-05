Git and Sequence Alignment
========================================================
author: Julin Maloof
date: April 05, 2018

Office Hours
=============

## Jiadong
* Mondays 3:00-4:00 93 Hutchison
* Fridays 10:00-11:00 2060 SciLab (this building)

## Maloof
* By appointment

Amazon limits
==============

* How many people still have "0" for t2.medium and t2.large instances?

* If you are still "0" in Oregon, please check the other US regions and see if you have anything there.

Today's Lab
========================================================

We will have two topics for today's lab

- Version control and collaboration with Git and GitHub
- Sequence Alignment using EMBOSS tools.

What is Git?
========================================================

* Tracks changes in projects and documents
* Can restore to an earlier state
* Can collaborate with others
* Can maintain different versions

What is Git?
========================================================

* An essential tool for software development
  * Should be used whether or not your are collaborating
* Enables transparent development and sharing
* Enables Documenation, Reproducibility, Openness

Git Intro Videos
===================

* [Video1](https://www.youtube.com/watch?v=8oRjP8yj2Wo)
* [Video2](https://www.youtube.com/watch?v=uhtzxPU7Bz0)

Git: Key concepts
=================
incremental: true
* Repository
  * A project that is tracked by Git
* To start a new repository
  * `git init`
* To add files to your repository
  * `git add`
* To save changes to your repository
  * `git commit`

***

* If you are going to collaborate you will need a
  * __remote__ repository 
* If you want to use a remote repository you need to
  * `fork` or `clone` it
* To download changes from the remote repository
  * `git pull`
* To upload changes to the remote repsoitory
  * `git push`
* (Illustrate on Board)

Git: Example
============
Show BIS180L_web example

  
Seq Alignment
=============

A key tool in bioinformatics is sequence alignment.

Why?

Seq Alignment
=============

Questions:  
1. How similar are two sequences?  
2. Given a protein of interest what other proteins are similar in another genome?

Part 2 of today's lab will have you explore tools for doing alignments and homolgy searches.

You can review principles of Sequence Alignment by looking at the Sequence Alignment Primer (linked to from the lab page).

How to decide on best alignment?
=================================
```
R I A C D H N
R I A N H N
```

How to decide on best alignment?
=================================
```
R I A C D H N
R I A N - H N
```

```
R I A C D H N
R I A - N H N
```

Scoring Matrix
================
Scoring matrices rate the matches in an alignment, based on evolutionary probability of occurence.
There are different matrices for different evolutionary distance.

(partial) BLOSUM62:

```
   A  R  N  D  C  Q  E  G  H  I
A  4 -1 -2 -2  0 -1 -1  0 -2 -1
R -1  5  0 -2 -3  1  0 -2  0 -3
N -2  0  6  1 -3  0  0  0  1 -3
D -2 -2  1  6 -3  0  2 -1 -1 -3
C  0 -3 -3 -3  9 -3 -4 -3 -3 -1
Q -1  1  0  0 -3  5  2 -2  0 -3
E -1  0  0  2 -4  2  5 -2  0 -3
G  0 -2  0 -1 -3 -2 -2  6 -2 -4
H -2  0  1 -1 -3  0  0 -2  8 -3
I -1 -3 -3 -3 -1 -3 -3 -4 -3  4
```

Scoring Matrix
================

```
   A  R  N  D  C  Q  E  G  H  I
A  4 -1 -2 -2  0 -1 -1  0 -2 -1
R -1  5  0 -2 -3  1  0 -2  0 -3
N -2  0  6  1 -3  0  0  0  1 -3
D -2 -2  1  6 -3  0  2 -1 -1 -3
C  0 -3 -3 -3  9 -3 -4 -3 -3 -1
Q -1  1  0  0 -3  5  2 -2  0 -3
E -1  0  0  2 -4  2  5 -2  0 -3
G  0 -2  0 -1 -3 -2 -2  6 -2 -4
H -2  0  1 -1 -3  0  0 -2  8 -3
I -1 -3 -3 -3 -1 -3 -3 -4 -3  4
```

```
R I A C D H N
R I A N - H N
```

```
R I A C D H N
R I A - N H N
```

Seq Alignment Signficance
=========================
incremental: true

How do you determine significance?

What does the null distribution look like?

Permutation: Create a randomized data set.

How does the real data compare to randomized data?

Order of events today
=====================

1. Git lab
2. Finish Unix lab if not yet done.
3. Start Sequence alignment lab.
