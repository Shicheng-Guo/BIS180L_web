---
layout: lab
title: Genetic Networks 1 - Clustering
hidden: true
tags:
     - networks
     - R
     - clustering
     - kmeans
     - hierarchical
     - heatmap
     - RNA-seq 
---

_This lab was designed by [Cody Markelz](http://rjcmarkelz.github.io/) a former postdoc in the Maloof Lab._

## Assignment repository
Please clone your `Assignment_7` repository and place your answers in the `Assignment_7_template.Rmd` notebook file.  When you are done push the .Rmd .html files

## Clustering Introduction
As you learned last lab, when we are dealing with genome scale data it is hard to come up with good summaries of the data unless you know exactly the question you are trying to ask. Today we will be explore three different ways to cluster data and get visual summaries of the expression of all genes that had a significant GxE interaction. Once we have these clusters, it allows us to ask further, more detailed questions such as what GO categories are enriched in each cluster, or are there specific metabolic pathways contained in the clusters? While clustering can be used in an exploratory way, the basics you will be learning today have been extended to very sophisticated statistical/machine learning methods used across many disciplines. In fact, there are many different methods used for clustering in R outlined in this **[CRAN VIEW](http://cran.r-project.org/web/views/Cluster.html)**.

The two clustering methods that we will be exploring are hierarchical clustering and k-means. These have important similarities and differences that we will discuss in detail throughout today. The basic idea with clustering is to find how similar the rows and/or columns in the data set are based on the values contained within the data frame. You used a similar technique last lab when you produced the MDS plot of samples. This visualization of the the samples in the data set showed that samples from similar genotype and treatment combinations were plotted next to one another based on their Biological Coefficient of Variation calculated across all of the counts of genes. 

## Hierarchical Clustering
An intuitive example is clustering the distances between know geographic locations, such as US Cities. I took this example from this [website](http://www.analytictech.com/networks/hiclus.htm).  The basic procedure is to:
 
1. Calculate a distance measure between all the row and column combinations in data set (think geographic distances between cities)
2. Start all the items in the data out as belonging to its own cluster (every city is its own cluster)
3. In the distance matrix, find the two closest points (find shortest distance between any two cities) 
4. Merge the two closest points into one cluster (merge BOS and NY in our example data set)
5. Repeat steps 3 and 4 until all the items belong to a single large cluster

A special note: all the clusters at each merge take on the shortest distance between any one member of the cluster and the remaining clusters. For example, the distance between BOS and DC is 429 miles, but the distance between NY and DC is 233. Because BOS/NY are considered one cluster after our first round, their cluster distance to DC is 233. All three of these cities are then merged into one cluster DC/NY/BOS.  (Alternative approached could be used, such as takign the mean distance or the longest distance).

Change into your Assignment_7 directory.

You should have a file `us_cities.txt` in your Assignment 7 directory.  If not, or if you are not in BIS180L, you can download it as indicated below and move it to your Assignment_7 directory.


```bash
wget http://jnmaloof.github.io/BIS180L_web/data/us_cities.txt
```

Install a library  
The `ggdendrogram` library makes nicer tree plots than the base package

```r
install.packages("ggdendro") #only needs to be done once
```


```r
library(tidyverse)
library(ggdendro)
```


Import the data


```r
cities <- read.delim("us_cities.txt",row.names = 1)

head(cities)
```


```
##       BOS   NY   DC  MIA  CHI  SEA   SF   LA  DEN
## BOS     0  206  429 1504  963 2976 3095 2979 1949
## NY    206    0  233 1308  802 2815 2934 2786 1771
## DC    429  233    0 1075  671 2684 2799 2631 1616
## MIA  1504 1308 1075    0 1329 3273 3053 2687 2037
## CHI   963  802  671 1329    0 2013 2142 2054  996
## SEA  2976 2815 2684 3273 2013    0  808 1131 1307
```

The function `as.dist()` tells R that the `cities` matrix should be used as a matrix.  The function `hclust()` performs hierarchical clustering on the distance matrix.

```r
cities_hclust <- cities %>% as.dist() %>% hclust()
ggdendrogram(cities_hclust)
```

![plot of chunk unnamed-chunk-19]({{ site.baseurl }}/figure/unnamed-chunk-19-1.png)


**Exercise 1:**
Extending the example that I gave for BOS/NY/DC, what are the distances that define each split in the West Coast side of the hclust plot? 
*Hint 1: Start with the distances between SF and LA. Then look at the difference between that cluster up to SEA*
*Hint 2: Print cities, you only need to look at the upper right triangle of data matrix.*

What is the city pair and distance the joins the East Coast and West Coast cities? Fill in the values.
Hint: Think Midwest.


Now that we have that example out of the way, lets start using this technique on biological data. This week will be a review of all the cool data manipulation steps you have learned in past weeks. I would like to emphasize that printing dataframes (or parts of them) is a really fast way to get an idea about the data you are working with. Visual summaries like printed data, or plotting the data are often times the best way to make sure things are working the way they should be and you are more likely to catch errors. I have included visual summaries at all of the points where I would want to check on the data. 

If you remember last week, you found some genes that had significant GxE in the internode tissue. We are going to be taking a look at those same genes again this week. That data set that you used only had 12 RNA-seq libraries in it. However, that subset of data was part of a much larger study that we are going to explore today. This data set consists of RNA-seq samples collected from 2 genotypes of *Brassica rapa* (R500 and IMB211) that were grown in either dense (DP) or non-dense planting (NDP) treatments. The researcher that did this stiudy, Upendra, also collected tissue from multiple tissue types including: Leaf, Petiole, Internode (you worked with this last week), and silique (the plant seed pod). There were also 3 biological replicates of each combination (Rep 1, 2, 3). If your head is spinning thinking about all of this, do not worry, data visualization will come to the rescue here in a second.

Remember last week when we were concerned with what distribution the RNA-seq count data was coming from so that we could have a good statistical model of it? Well, if we want to perform good clustering we also need to think about this because most of the simplest clustering assumes data to be from a normal distribution. I have transformed the RNAseq data to be normally distributed for you, but if you every need to do it yourself you can do so with the function `voom` from the `limma` package.  

Lets start by loading the two data sets. Then we can subset the larger full data set to include only the genes that we are interested in from our analysis last week.


```bash
wget http://jnmaloof.github.io/BIS180L_web/data/DEgenes_GxE.csv
wget http://jnmaloof.github.io/BIS180L_web/data/voom_transform_brassica.csv
```


```r
# make sure to change the path to where you downloaded this using wget
DE_genes <- read_csv("../data/DEgenes_GxE.csv")
head(DE_genes) #check out the data
```

```
## # A tibble: 6 x 6
##   GeneID    logFC logCPM    LR   PValue      FDR
##   <chr>     <dbl>  <dbl> <dbl>    <dbl>    <dbl>
## 1 Bra010821  6.66   6.04 153.  3.54e-35 8.51e-31
## 2 Bra033034 -4.64   6.61  71.3 3.13e-17 3.76e-13
## 3 Bra035334 -4.14   4.67  68.3 1.37e-16 1.10e-12
## 4 Bra003598 -4.89   3.90  54.2 1.85e-13 1.11e- 9
## 5 Bra016182  7.71   6.33  49.6 1.87e-12 9.00e- 9
## 6 Bra013164  4.10   9.33  47.9 4.38e-12 1.76e- 8
```

```r
# make sure to change the path to where you downloaded this using wget
brass_voom_E <- read_csv("../data/voom_transform_brassica.csv")
head(brass_voom_E)
```

```
## # A tibble: 6 x 49
##   GeneID    IMB211_DP_1_INTERNODE IMB211_DP_1_LEAF IMB211_DP_1_PETIOLE
##   <chr>                     <dbl>            <dbl>               <dbl>
## 1 Bra000002                 1.86             -3.43                4.22
## 2 Bra000003                 5.37              6.35                6.52
## 3 Bra000004                 0.624             2.00                1.99
## 4 Bra000005                 5.90              4.85                5.75
## 5 Bra000006                 4.35              3.20                4.73
## 6 Bra000007                 1.18              1.53                2.70
## # ... with 45 more variables: IMB211_DP_1_SILIQUE <dbl>,
## #   IMB211_DP_2_INTERNODE <dbl>, IMB211_DP_2_LEAF <dbl>,
## #   IMB211_DP_2_PETIOLE <dbl>, IMB211_DP_2_SILIQUE <dbl>,
## #   IMB211_DP_3_INTERNODE <dbl>, IMB211_DP_3_LEAF <dbl>,
## #   IMB211_DP_3_PETIOLE <dbl>, IMB211_DP_3_SILIQUE <dbl>,
## #   IMB211_NDP_1_INTERNODE <dbl>, IMB211_NDP_1_LEAF <dbl>,
## #   IMB211_NDP_1_PETIOLE <dbl>, IMB211_NDP_1_SILIQUE <dbl>,
## #   IMB211_NDP_2_INTERNODE <dbl>, IMB211_NDP_2_LEAF <dbl>,
## #   IMB211_NDP_2_PETIOLE <dbl>, IMB211_NDP_2_SILIQUE <dbl>,
## #   IMB211_NDP_3_INTERNODE <dbl>, IMB211_NDP_3_LEAF <dbl>,
## #   IMB211_NDP_3_PETIOLE <dbl>, IMB211_NDP_3_SILIQUE <dbl>,
## #   R500_DP_1_INTERNODE <dbl>, R500_DP_1_LEAF <dbl>,
## #   R500_DP_1_PETIOLE <dbl>, R500_DP_1_SILIQUE <dbl>,
## #   R500_DP_2_INTERNODE <dbl>, R500_DP_2_LEAF <dbl>,
## #   R500_DP_2_PETIOLE <dbl>, R500_DP_2_SILIQUE <dbl>,
## #   R500_DP_3_INTERNODE <dbl>, R500_DP_3_LEAF <dbl>,
## #   R500_DP_3_PETIOLE <dbl>, R500_DP_3_SILIQUE <dbl>,
## #   R500_NDP_1_INTERNODE <dbl>, R500_NDP_1_LEAF <dbl>,
## #   R500_NDP_1_PETIOLE <dbl>, R500_NDP_1_SILIQUE <dbl>,
## #   R500_NDP_2_INTERNODE <dbl>, R500_NDP_2_LEAF <dbl>,
## #   R500_NDP_2_PETIOLE <dbl>, R500_NDP_2_SILIQUE <dbl>,
## #   R500_NDP_3_INTERNODE <dbl>, R500_NDP_3_LEAF <dbl>,
## #   R500_NDP_3_PETIOLE <dbl>, R500_NDP_3_SILIQUE <dbl>
```

```r
GxE_counts <- DE_genes %>% select(GeneID) %>% left_join(brass_voom_E) #get count data specifically for the GxE genes
head(GxE_counts)
```

```
## # A tibble: 6 x 49
##   GeneID    IMB211_DP_1_INTERNODE IMB211_DP_1_LEAF IMB211_DP_1_PETIOLE
##   <chr>                     <dbl>            <dbl>               <dbl>
## 1 Bra010821              -3.46                1.70               0.134
## 2 Bra033034               8.32               -3.43              -1.24 
## 3 Bra035334               6.01                2.62               2.81 
## 4 Bra003598               4.05                6.09               5.10 
## 5 Bra016182              -0.00370            -1.84               5.38 
## 6 Bra013164               4.25               -3.43               2.64 
## # ... with 45 more variables: IMB211_DP_1_SILIQUE <dbl>,
## #   IMB211_DP_2_INTERNODE <dbl>, IMB211_DP_2_LEAF <dbl>,
## #   IMB211_DP_2_PETIOLE <dbl>, IMB211_DP_2_SILIQUE <dbl>,
## #   IMB211_DP_3_INTERNODE <dbl>, IMB211_DP_3_LEAF <dbl>,
## #   IMB211_DP_3_PETIOLE <dbl>, IMB211_DP_3_SILIQUE <dbl>,
## #   IMB211_NDP_1_INTERNODE <dbl>, IMB211_NDP_1_LEAF <dbl>,
## #   IMB211_NDP_1_PETIOLE <dbl>, IMB211_NDP_1_SILIQUE <dbl>,
## #   IMB211_NDP_2_INTERNODE <dbl>, IMB211_NDP_2_LEAF <dbl>,
## #   IMB211_NDP_2_PETIOLE <dbl>, IMB211_NDP_2_SILIQUE <dbl>,
## #   IMB211_NDP_3_INTERNODE <dbl>, IMB211_NDP_3_LEAF <dbl>,
## #   IMB211_NDP_3_PETIOLE <dbl>, IMB211_NDP_3_SILIQUE <dbl>,
## #   R500_DP_1_INTERNODE <dbl>, R500_DP_1_LEAF <dbl>,
## #   R500_DP_1_PETIOLE <dbl>, R500_DP_1_SILIQUE <dbl>,
## #   R500_DP_2_INTERNODE <dbl>, R500_DP_2_LEAF <dbl>,
## #   R500_DP_2_PETIOLE <dbl>, R500_DP_2_SILIQUE <dbl>,
## #   R500_DP_3_INTERNODE <dbl>, R500_DP_3_LEAF <dbl>,
## #   R500_DP_3_PETIOLE <dbl>, R500_DP_3_SILIQUE <dbl>,
## #   R500_NDP_1_INTERNODE <dbl>, R500_NDP_1_LEAF <dbl>,
## #   R500_NDP_1_PETIOLE <dbl>, R500_NDP_1_SILIQUE <dbl>,
## #   R500_NDP_2_INTERNODE <dbl>, R500_NDP_2_LEAF <dbl>,
## #   R500_NDP_2_PETIOLE <dbl>, R500_NDP_2_SILIQUE <dbl>,
## #   R500_NDP_3_INTERNODE <dbl>, R500_NDP_3_LEAF <dbl>,
## #   R500_NDP_3_PETIOLE <dbl>, R500_NDP_3_SILIQUE <dbl>
```

```r
GxE_counts <- GxE_counts %>% column_to_rownames("GeneID") %>% as.matrix() # some of the downstream steps require a data matrix
head(GxE_counts[,1:6])
```

```
##           IMB211_DP_1_INTERNODE IMB211_DP_1_LEAF IMB211_DP_1_PETIOLE
## Bra010821          -3.463127655         1.701664           0.1337041
## Bra033034           8.321098205        -3.427619          -1.2448076
## Bra035334           6.006514162         2.616775           2.8083038
## Bra003598           4.052572183         6.092017           5.0986003
## Bra016182          -0.003696037        -1.842657           5.3816316
## Bra013164           4.251117862        -3.427619           2.6427177
##           IMB211_DP_1_SILIQUE IMB211_DP_2_INTERNODE IMB211_DP_2_LEAF
## Bra010821           2.4624596             -1.601140         2.942148
## Bra033034           0.7124379              8.236488        -3.597011
## Bra035334           1.7765682              6.769547         1.612442
## Bra003598           1.5009338              4.281503         5.753928
## Bra016182           1.7765682             -1.601140        -2.012048
## Bra013164           6.5337770              5.353056        -2.012048
```

Be sure that you understand how the above steps worked!

Now that we have a dataframe containing our 255 significant GxE genes from the internode tissue, we can take a look at how these genes are acting across all tissues.

We use the `dist()`function to compute the Euclidean distance between our data points.  (Other distance metrics are available, look at `?dist` if you are curious.)


```r
gene_hclust_row <- GxE_counts %>% dist() %>% hclust()
ggdendrogram(gene_hclust_row)
```

![plot of chunk unnamed-chunk-22]({{ site.baseurl }}/figure/unnamed-chunk-22-1.png)
What a mess! We have clustered similar genes to one another but that are too many genes, so we are overplotted in this direction. How about if we cluster by column instead? Notice we have to transpose the data using `t()`. Also, make sure you stretch out the window so you can view it! 


**Exercise 2:**
What is the general pattern in the h-clustering data? 
Using what you learned from the city example, what is the subcluster that appears to be very different than the rest of the samples? 
*Hint: You may need to plot this yourself and stretch it out if the rendering on the website compresses the output.  In your .Rmd file you can click on the left icon above the plot to display it in its own windows*

We have obtained a visual summary using h-clustering. Now what? We can go a little further and start to define some important sub-clusters within our tree. We can do this using the following function. Once again make sure you plot it so you can stretch the axes. 

Here we have to use the "base" plotting function...


```r
?rect.hclust
plot(gene_hclust_col) #redraw the tree everytime before adding the rectangles
rect.hclust(gene_hclust_col, k = 4, border = "red")
```

![plot of chunk unnamed-chunk-24]({{ site.baseurl }}/figure/unnamed-chunk-24-1.png)
**Exercise 3:**
__a__ With k = 4 as one of the arguments to the rect.hclust() function, what is the largest and smallest group contained within the rectangles? 

__b__ What does the k parameter specify?

__c__ Play with the k-values between 3 and 7. Describe how the size of the clusters change when changing between k-values.

You may have noticed that your results and potential interpretation of the data could change very dramatically based on the how many subclusters you choose! This is one of the main drawbacks with this technique. Fortunately there are other packages such as `pvclust` that can help us determine which sub-clusters have good support. 

The package pvclust assigns p-values to clusters.  It does this by bootstrap sampling of our dataset.  Bootstrapping is a popular resampling technique that you can read about more [here](http://en.wikipedia.org/wiki/Bootstrapping_%28statistics%29).  The basic idea is that many random samples of your data are taken and the clustering is done on each of these resampled data sets.  We then ask how often the branches present in the original data set appear in the resampled data set.  If a branch appears many times in the resampled data set that is good evidence that it is "real".



```r
library(pvclust)
?pvclust #check out the documentation

set.seed(12456) #This ensure that we will have consistent results with one another

fit <- pvclust(GxE_counts, method.hclust = "ward.D", method.dist = "euclidean", nboot = 50)
```

```
## Bootstrap (r = 0.5)... Done.
## Bootstrap (r = 0.6)... Done.
## Bootstrap (r = 0.7)... Done.
## Bootstrap (r = 0.8)... Done.
## Bootstrap (r = 0.9)... Done.
## Bootstrap (r = 1.0)... Done.
## Bootstrap (r = 1.1)... Done.
## Bootstrap (r = 1.2)... Done.
## Bootstrap (r = 1.3)... Done.
## Bootstrap (r = 1.4)... Done.
```

```r
plot(fit) # dendogram with p-values
```

![plot of chunk unnamed-chunk-25]({{ site.baseurl }}/figure/unnamed-chunk-25-1.png)
The green values are the "Bootstrap Percentage" (BP) values, indicating the percentage of bootstramp samples where that branch was observed.  Red values are the "Approximate Unbiased" (AU) values which scale the BP based on the number of samples that were taken. In both cases numbers closer to 100 provide more support. 

**Exercise 4:**
After running the 50 bootstrap samples, make a new plot but change nboot up to 1000. In general what happens to BP and AU?


We will be discussing more methods for choosing the number of clusters in the k-means section. Until then, we will expand what we learned about h-clustering to do a more sophisticated visualization of the data. 

## Heatmaps
Heatmaps are another way to visualize h-clustering results. Instead of looking at either the rows (genes) or the columns (samples) like we did with the h-clustering examples we can view the entire data matrix at once. How do we do this? We could print the matrix, but that would just be a bunch of numbers. Heatmaps take all the values within the data matrix and convert them to a color value. The human eye is really good at picking out patterns so lets convert that data matrix to a color value AND do some h-clustering. Although we can do this really easily with the heatmap() function that comes preloaded in R, there is a small library that provides some additional functionality for heatmaps. We will start with the cities example because it is small and easy to see what is going on. 

*A general programming tip: always have little test data sets. That allows you to figure out what the functions are doing. If you understand how it works on a small scale then you will be better able to troubleshoot when scaling to large datasets.*


```r
library(gplots) #not to be confused with ggplot2!
head(cities) # city example
```

```
##       BOS   NY   DC  MIA  CHI  SEA   SF   LA  DEN
## BOS     0  206  429 1504  963 2976 3095 2979 1949
## NY    206    0  233 1308  802 2815 2934 2786 1771
## DC    429  233    0 1075  671 2684 2799 2631 1616
## MIA  1504 1308 1075    0 1329 3273 3053 2687 2037
## CHI   963  802  671 1329    0 2013 2142 2054  996
## SEA  2976 2815 2684 3273 2013    0  808 1131 1307
```

```r
?heatmap.2 #take a look at the arguments
heatmap.2(as.matrix(cities), Rowv=as.dendrogram(cities_hclust), scale="row", density.info="none", trace="none")
```

![plot of chunk unnamed-chunk-26]({{ site.baseurl }}/figure/unnamed-chunk-26-1.png)
**Exercise 5:**
We used the scale rows option. This is necessary so that every *row* in the data set will be on the same scale when visualized in the heatmap. This is to prevent really large values somewhere in the data set dominating the heatmap signal. Remember if you still have this data set in memory you can take a look at a printed version to the terminal. Compare the distance matrix that you printed with the colors of the heat map. See the advantage of working with small test sets? Take a look at your plot of the cities heatmap and interpret what a dark red value and a light yellow value in the heatmap would mean in geographic distance. Provide an example of of each in your explanation.


## Now for some gene expression data. 


```r
plot(gene_hclust_row)
heatmap.2(GxE_counts, Rowv = as.dendrogram(gene_hclust_row), scale = "row", density.info="none", trace="none")
```
**Exercise 6:** The genes are overplotted so we cannot distinguish one from another. However, what is the most obvious pattern that you can pick out from this data? Describe what you see. 

**Exercise 7:** In the similar way that you interpreted the color values of the heatmap for the city example, come up with a biological interpretation of the yellow vs. red color values in the heatmap. What would this mean for the pattern that you described in exercise 6? Discuss.

## k-means clustering
[K-means clustering](https://en.wikipedia.org/wiki/K-means_clustering) tries to fit "centering points" to your data by chopping your data up into however many "k" centers you specify. If you pick 3, then you are doing 3-means centering to your data or trying to find the best 3 centers that describe all of your data. The basic steps are:

1. Randomly assign each sample in your data set to one of k clusters.
2. Calculate the mean of each cluster (aka the center)
3. Update the assignments by assigning samples to the cluster whose mean they are closest to.
4. Repeat steps 2 and 3 until assignments stop changing.

To build some intuition about how these things work there is a cool R package called "animation". You do not have to run the following code, but I will use it to demonstrate a few examples in class. These examples are based directly on the **[documentation](cran.r-project.org/web/packages/animation/animation.pdf)** for the functions so if you wanted to look at how some other commonly used methods work with a visual summary I encourage you to check out this package on your own time.

To learn about when k-means is not a good idea, see [this post](http://varianceexplained.org/r/kmeans-free-lunch/)


```r
# you do not have to run this code chunk
# library(animation) 

# kmeans.ani(x = cbind(X1 = runif(50), X2 = runif(50)), centers = 3,
# hints = c("Move centers!", "Find cluster?"), pch = 1:3, col = 1:3)

# kmeans.ani(x = cbind(X1 = runif(50), X2 = runif(50)), centers = 10,
# hints = c("Move centers!", "Find cluster?"), pch = 1:3, col = 1:3)

# kmeans.ani(x = cbind(X1 = runif(50), X2 = runif(50)), centers = 5,
# hints = c("Move centers!", "Find cluster?"), pch = 1:3, col = 1:3)
```

Now that you have a sense for how this k-means works, lets apply what we know to our data.  Lets start with 9 clusters, but please play with the number of clusters and see how it changes the visualization. We will need to run a quick Principle Component Analysis (similar to MDS), on the data in order to visualize how the clusters are changing with different k-values.


```r
library(ggplot2)
prcomp_counts <- prcomp(t(GxE_counts)) #gene wise
scores <- as.data.frame(prcomp_counts$rotation)[,c(1,2)]

set.seed(25) #make this repeatable as kmeans has random starting positions
fit <- kmeans(GxE_counts, 9)
clus <- as.data.frame(fit$cluster)
names(clus) <- paste("cluster")

plotting <- merge(clus, scores, by = "row.names")
plotting$cluster <- as.factor(plotting$cluster)

# plot of observations
ggplot(data = plotting, aes(x = PC1, y = PC2, label = Row.names, color = cluster)) +
  geom_hline(yintercept = 0, colour = "gray65") +
  geom_vline(xintercept = 0, colour = "gray65") +
  geom_point(alpha = 0.8, size = 4, stat = "identity") 
```
**Exercise 8:** Pretty Colors! Describe what you see visually with 2, 5, 9, and 15 clusters. Why would it be a bad idea to have to few or to many clusters? Discuss with a specific example comparing few vs. many k-means. Justify your choice of too many and too few clusters by describing what you see in each case.
The final thing that we will do today is try to estimate, based on our data, what the ideal number of clusters is. For this we will use something called the Gap statistic. 



```r
library(cluster)
set.seed(125)
gap <- clusGap(GxE_counts, FUN = kmeans, iter.max = 30, K.max = 20, B = 500, verbose=interactive())
plot(gap, main = "Gap Statistic")
```
This is also part of the cluster package that you loaded earlier. It will take a few minutes to calculate this statistic. In the mean time, check out some more information about it in the ?clusGap documentation. We could imagine that as we increase the number of k-means to estimate, we are always going to increase the fit of the data. The extreme examples of this would be if we had k = 255 for the total number of genes in the data set or k = 1. We would be able to fit the data perfectly in the k = 255 case, but what has it told us? It has not really told us anything. Just like you played with the number of k-means in Exercise 8, we can also do this computationally! We want optimize to have the fewest number of clusters that  can explain the variance in our data set.

**Exercise 9:** Based on this Gap statistic plot at what number of k clusters (x-axis) do you start to see diminishing returns? To put this another way, at what value of k does k-1 and k+1 start to look the same for the first time? Or yet another way, when are you getting diminishing returns for adding more k-means? See if you can make the trade off of trying to capture a lot of variation in the data as the Gap statistic increases, but you do not want to add too many k-means because your returns diminish as you add more. Explain your answer using the plot as a guide to help you interpret the data.

Now we can take a look at the plot again and also print to the terminal what clusGap() calculated. 


```r
with(gap, maxSE(Tab[,"gap"], Tab[,"SE.sim"], method="firstSEmax"))
```
**Exercise 10:** What did clusGap() calculate? How does this compare to your answer from Exercise 9? Make a plot using the kmeans functions as you did before, but choose the number of k-means you chose and the number of k-means that are calculated from the Gap Statistic. Describe the differences in the plots.

Good Job Today! There was a lot of technical stuff to get through. If you want more (or even if you don't), check out the "Genetic Networks-2" lab where you can build co-expression networks and study their properties using a few of the techniques that you learned today. BIS180L will do this on Thursday.
