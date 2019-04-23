---
title: "BLAST part 2"
layout: lab
tags: R
hidden: true
---

For this lab we will continue to expand our R toolkit and apply what we learn to the BLAST results.

## Exercise template

__IMPORTANT__ The `Assignment_3_template_2.Rmd` in your repo HAS BEEN UPDATED.  __PLEASE REPULL YOUR REPO TO GET THE CURRENT VERSION__.  Then use this file to answer the exercises below.  

## Joins

Often we will have different data sets that we want to combine in some way.  For example, we might want to combine our reciprocal BLAST results into a single data frame.

### Join Tutorial

To learn how to do this please complete the tutorial that I wrote on joins.  

If you haven't already installed the tutorial package you can do so with:

```r
#you do not need to run this if you installed it during the previous lab "R Practice"
devtools::install_github("UCDBIS180L/BIS180LTutorials") 
```

Then, start the tutorial with:

```r
learnr::run_tutorial("Joins", package = "BIS180LTutorials") 
```

### Join the blast results

Let's say we want to find *all* of the Arabidopsis genes with reciprocal best hits in the worm genome.  How would we do that?  Let's think of the steps:

1. For each query record best hit, record the E-value of the second-best hit.
2. Filter our hits to retain only the best hit. 
3. Join the two worm->plant and plant->worm sets together
4. Filter to keep genes with reciprocal best hits.

Load the data.  Adjust the paths to work on your computer.

```r
library(tidyverse)
library(stringr) #character string manipulation

plant_worm <- read_tsv("../data/plant_vs_worm.blastout_v2.1.gz",
                       col_names=c("query_id",
                                   "subject_id",
                                   "pct_ident",
                                   "len",
                                   "mis",
                                   "gaps",
                                   "qb",
                                   "qe",
                                   "sb",
                                   "se",
                                   "E",
                                   "Score"))
worm_plant <- read_tsv("../data/worm_vs_plant.blastout_v2.1.gz",
                       col_names=c("query_id",
                                   "subject_id",
                                   "pct_ident",
                                   "len",
                                   "mis",
                                   "gaps",
                                   "qb",
                                   "qe",
                                   "sb",
                                   "se",
                                   "E",
                                   "Score"))
```

Make a column recording E-value of the next best hit.


```r
plant_worm <- plant_worm %>% 
  arrange(query_id, E) %>% 
  group_by(query_id) %>% 
  mutate(nextE = lead(E)) %>%
  ungroup()
head(plant_worm,12)

worm_plant <- worm_plant %>% 
  arrange(query_id, E) %>% 
  group_by(query_id) %>% 
  mutate(nextE = lead(E)) %>%
  ungroup()
head(worm_plant,12)
```

**Exercise 1**
Look at the help page for `lead` and examine the `E` and `nextE` columns.  What does `lead()` do?  Why are there NAs in the `nextE` column?

We want to know the difference between the E-value of the best hit and the next best hit.  It will be easiest to read if convert the E-values to log10 scale first.


```r
plant_worm <- plant_worm %>% mutate(E_diff=log10(E)-log10(nextE))
worm_plant <- worm_plant %>% mutate(E_diff=log10(E)-log10(nextE))
```

### Logarithm review

If you need a review on logarithms the [math is fun site](https://www.mathsisfun.com/algebra/logarithms.html) is a good choice.  Also experiment with the code below

When we are dealing with log base 10, then log represents the number of times that we would have to multiple 10 by itself to reach the number that we want to take the log of.

For example, what is the log10 of 1,000?  Well how many times do we have to multiply 10 by itself to equal 1,000?  Three times.  In R:

```r
log10(1000)
```

```
## [1] 3
```

We can convert from a log10 value back to the original number by raising 10 to that power

```r
10^3
```

```
## [1] 1000
```

For numbers less than 1 we are multiplying by 1/10, so the log is negative.  How many times do we have to multiple 1/10 to itself to equal 0.001?


```r
log10(0.001)
```

```
## [1] -3
```

and reverse it:

```r
10^-3
```

```
## [1] 0.001
```


Now lets filter these to keep the best hit, as we did in the last lab.  Also, we use select to only keep relevant columns.


```r
plant_worm_best <- plant_worm %>%
  arrange(query_id, E, desc(Score)) %>%
  filter(!duplicated(query_id)) %>%
  select(query_id, subject_id, pct_ident, len, E, nextE, E_diff, Score)
```


```r
worm_plant_best <- worm_plant %>%
  arrange(query_id, E, desc(Score)) %>%
  filter(!duplicated(query_id)) %>%
  select(query_id, subject_id, pct_ident, len, E, nextE, E_diff, Score)
```


Now let's create a table of Arabidopsis genes that includes the reciprocal blast results

```r
plant_with_recip <- left_join(plant_worm_best, worm_plant_best,
                              by=c("subject_id"="query_id"),
                              suffix = c(".plant_worm", ".worm_plant")) %>%
  select(query_id, subject_id, subject_id.worm_plant, everything()) # rearrange columns 

head(plant_with_recip,10)
```


**Exercise 2**
CHANGED FOR 2019; PLEASE ANSWER THIS QUESTION FOR EXERCISE 2, EVEN IF YOU TEMPLATE READS DIFFERENTLY:
Explain the effect of `by=c("subject_id"="query_id")` in the above code.  What does this do and why are we joining this way?

**Exercise 3**
We next need to filter the `plant_with_recip` tibble to create a new tibble that only has the candidate ortholog pairs.  Consider what criteria you should use:

* What relationship do you want between the "query_id" and "subject_id.worm_plant" columns?
* E-value threshold for "E.plant_worm".  I recommend < 1e-04; what is this filter doing?
* Threshold for E_diff.plant_worm.  I recommend < -2; what is this filter doing?

Filter the results based on the above criteria to retain only those rows where there is a reciprocal blast that also meet the E-value E-value and E_diff thresholds; place the results in a new object `plant_with_worm_orthologs`

How many candidate orthologs do you have?



**Exercise 4**
Repeat the analysis above, but this time create a table of worm genes that have plant orthologs.  How many do you have?







## Intro to plotting with ggplot

One of the strengths of R is its graphics.  Ggplot is a particularly nice package for plotting.

I have written a tutorial to help you learn the ggplot package.  Please work through the tutorial now:


```r
learnr::run_tutorial("ggplot", package = "BIS180LTutorials") 
```

### Visualization of the BLAST data set

Now lets apply what we have learned to the BLAST data set.

**Exercise 5**
Use ggplot to explore the relationship between score ("Score") and alignment length("len") in the "worm_plant_best" data set.  Provide a plot that illustrates the relationship and describe the relationship in words.



**Exercise 6**
How does percent identity ("pct_identity") affect the relationship between score and length?  Update your plot from exercise 5 to include pct_identity in a way that can help you answer the question.



**Exercise 7**
Continuing to use the "worm_plant_best" data set, make a plot that shows the relationship between E-value ("E") and score ("Score").  If your plot looks like an "L" think about how to transform the axis or axes scale to make the plot more informative.  You may want to filter to remove E values that are 0.  Try it both ways.  




**Exercise 8**
In the previous lab's Exercise 10 you were asked to "State a hypothesis about what alignment properties might produce a zero E-value even when the percent identity is less than 50%." and then to test it.  Now make a plot to illustrate your hypothesis / test.  Probably you want a boxplot or a violin plot.

**Turning in the assignment**

* For both this template and for part 1:
* Click the "Preview" Button to generate an up-to-date html version of your notebook.  Check it to make sure you are happy with its content.
* add your .Rmd and .nb.html files to the repository and commit the changes.
* push the changes
