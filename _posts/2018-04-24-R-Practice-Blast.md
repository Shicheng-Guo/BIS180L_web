---
title: "BLAST part 2"
layout: lab
tags: R
hidden: true
---

For this lab we will continue to expand our R toolkit and apply what we learn to the BLAST results.

## Get the exercise template

There is a second template to use to answer the exercises below.  To get it:

* Commit any changes to your `Assignment_3_template_1` files
* Pull your Assignment_3 repository
* Open the `Assignment_3_template_2.Rmd` file.

## Joins

Often we will have different data sets that we want to combine in some way.  For example, we might want to combine our reciprocal BLAST results into a single data frame.

### Join Tutorial

To learn how to do this please complete the tutorial that I wrote on joins.  You will need to re-install the tutorial package and then start the tutorial:


```r
devtools::install_github("UCDBIS180L/BIS180LTutorials") # needs to be reinstalled to get the new tutorial

learnr::run_tutorial("Joins", package = "BIS180LTutorials") 
```

### Join the blast results

Let's say we want to find *all* of the Arabidopsis genes with reciprocal best hits in the worm genome.  How would we do that?  Let's think of the steps:

1. For each query record the E-value of the second-best hit.
2. Filter our hits to retain only the best hit. 
3. Join the two data sets together
4. Filter to keep genes with reciprocal best hits.

Load the data.  Adjust the paths to work on your computer.

```r
library(tidyverse)
library(stringr) #character string manipulation

plant_worm <- read_tsv("../data/plant_vs_worm.blastout.gz",
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
worm_plant <- read_tsv("../data/worm_vs_plant.blastout.gz",
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



Now lets filter these to keep the best hit, as we did in the last lab.  Also use select to only keep relevant columns.


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


The `subject_id` in the plant_worm_best set is too long and needs to be shortened to just the gene_id.  `str_replace` searches for its second argument and replaces it with its third.  We are using wildcards (technically regular expressions) to search for strings that begin with "#" and replace them with nothing.  Hopefully there will be time to explain this in more detail in a later lab.


```r
head(plant_worm_best$subject_id) #yikes!

plant_worm_best <- plant_worm_best %>%
  mutate(subject_id=str_replace(subject_id,"#.*",""))

head(plant_worm_best$subject_id) #better
```

Now let's create a table of Arabidopsis genes that includes the reciprocal blast results


```r
plant_with_recip <- left_join(plant_worm_best, worm_plant_best,
                              by=c("subject_id"="query_id"),
                              suffix = c(".plant_worm", ".worm_plant")) %>%
  select(query_id, subject_id, subject_id.worm_plant, everything()) # rearrange columns 

head(plant_with_recip,10)
```

Unfortunately, having multiple isoforms makes this hard to sort through.  It would have been best to start with a proteome file that only had one, canonical isoform per gene.  At this point we will keep the isoform with the overall best score in its blast against worm:


```r
plant_with_recip <- plant_with_recip %>%
  mutate(query_id=str_sub(query_id,1,9), 
         subject_id.worm_plant=str_sub(subject_id.worm_plant,1,9)) %>%
  arrange(query_id,Score.plant_worm) %>%
  filter(!duplicated(query_id)) %>%
  ungroup()

head(plant_with_recip,10)                          
```

**Exercise 2**

* What is the `str_sub()` function doing?
* What does the "subject_id" column represent?
* What does the "subject_id.worm_plant" column represent?

**Exercise 3**

Filter the `plant_with_recip` tibble to create a new tibble `plant_with_worm_orthologs`.  Consider what criteria you should use:

* What relationship do you want between the "query_id" and "subject_id.worm_plant" columns?
* E-value threshold for "E.plant_worm".  I recommend < 1e-04
* Threshold for E_diff.plant_worm.  I recommend < -2 

What does an E_diff.plant_worm threshold of < -2 mean?

Filter the results based on the above criteria to retain only those rows where there is a reciprocal blast that also meet the E-value E-value and E_diff thresholds; place the results in a new object `plant_with_worm_orthologs`

How many candidate orthologs do you have?



**Exercise 4**
Repeat the analysis above, but this time create a table of worm genes that have plant orthologs.  How many do you have?

Hint: The code needed to remove isoforms is a little bit different for the worm proteins and is shown below.  You will still need to use left_join to create worm_with_recip before running the code below, and then filter afterwards.





```r
worm_with_recip <- worm_with_recip %>%
  mutate(query_id=str_replace(query_id,"[a-z]$",""), 
         subject_id.plant_worm=str_replace(subject_id.plant_worm,"[a-z]$","")) %>%
  arrange(query_id,Score.worm_plant) %>%
  filter(!duplicated(query_id)) %>%
  ungroup()
```





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
