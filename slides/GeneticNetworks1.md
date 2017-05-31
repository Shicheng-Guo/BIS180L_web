Genetic Networks 1: Clustering
========================================================
author: Julin Maloof
date: 05-30-2017
autosize: true

Clustering
============

An alternative to doing differential gene expression analysis for RNAseq data is to look for _patterns_ in the data.

This can be particularly uesful as the datsets get larger.

The 12 samples your worked with last week are part of a much larger data set.  Today we will work with 48 samples from the same experiment.

Clustering Goals
==================

1. Identify groups of _samples_ with similar expression patterns (why?)
2. Identify groups of _genes_ with similar expression patterns (why?)

Clustering methods
==================

We will explore three types of clustering:

1. Hierarchical Clustering (today)
2. K-means clustering (today) 
3. Co-expression (Thursday) 

Hierarchical Clustering
=======================

Basic idea:

1. Calculate distances between each pair of samples (or genes)
2. Pair the closest samples together
3. Recalculate distances
4. pair the closest samples
5. repeat 3 and 4

let's try it on some cities

Cities
======

|    |  BOS|   NY|   DC|  MIA|  CHI|  SEA|   SF|   LA|  DEN|
|:---|----:|----:|----:|----:|----:|----:|----:|----:|----:|
|BOS |    0|  206|  429| 1504|  963| 2976| 3095| 2979| 1949|
|NY  |  206|    0|  233| 1308|  802| 2815| 2934| 2786| 1771|
|DC  |  429|  233|    0| 1075|  671| 2684| 2799| 2631| 1616|
|MIA | 1504| 1308| 1075|    0| 1329| 3273| 3053| 2687| 2037|
|CHI |  963|  802|  671| 1329|    0| 2013| 2142| 2054|  996|
|SEA | 2976| 2815| 2684| 3273| 2013|    0|  808| 1131| 1307|
|SF  | 3095| 2934| 2799| 3053| 2142|  808|    0|  379| 1235|
|LA  | 2979| 2786| 2631| 2687| 2054| 1131|  379|    0| 1059|
|DEN | 1949| 1771| 1616| 2037|  996| 1307| 1235| 1059|    0|

K-means clustering
==================

Basic idea:

1. Define the number of clusters desired
2. Randomly assign each gene to a cluster
3. Calculate the mean of each cluster
4. Assign each gene to the cluster whose mean they are closest to
5. Repeat until stable.

K-means animation
==================

```r
library(animation) 

kmeans.ani(x = cbind(X1 = runif(50), X2 = runif(50)), centers = 3,
hints = c("Move centers!", "Find cluster?"), pch = 1:3, col = 1:3)
```

K-means animation
==================

```r
kmeans.ani(x = cbind(X1 = runif(50), X2 = runif(50)), centers = 10,
hints = c("Move centers!", "Find cluster?"), pch = 1:3, col = 1:3)

kmeans.ani(x = cbind(X1 = runif(50), X2 = runif(50)), centers = 5,
hints = c("Move centers!", "Find cluster?"), pch = 1:3, col = 1:3)
```

Gap-statistic
==============
How many clusters are enough?

Choose the number of clusters that maximizes the observed within-cluster variance as compared to expectation of random clusters.

