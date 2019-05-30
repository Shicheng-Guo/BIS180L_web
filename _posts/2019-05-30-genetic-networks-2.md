---
layout: lab
title: Genetic Networks 2 - Co-Expression 
hidden: true
tags:
     - networks
     - R
     - clustering
     - kmeans
     - RNA-seq 
     - graphs
--- 



# Introduction

## Biological Context 
In the past few weeks we have taken data off the sequencer, aligned the reads to our reference genome, calculated counts for the number of reads that mapped to each gene in our reference genome, found out what genes are differentially expressed between our genotype treatment combinations, and started to interpret the data using clustering. With these large data sets there is more than one way to look at the data. As biologists we need to critically evaluate what the data is telling us and interpret it using our knowledge of biological processes. In our case we have an environmental perturbation that we have imposed on the plants by altering the density of plants in a given pot. Understanding mechanistically how plants respond to crowding is important for understanding how plants grow and compete for resources in natural ecosystems, and how we might manipulate plants to grow optimally in agroecosystems. In our case, we have two genotypes of plants that show very different physiological and morphological responses to crowding. We have a lot of data, some quantitative, some observational, that support this. Plant growth, just like the growth of any organism, is a really complicated thing. Organisms have evolved to interact with the environment by taking in information from their surroundings and trying to alter their physiology and biochemistry to better live in that environment. We know a lot about the details of how these signals are intercepted by the organisms, but we know less how this translates to changes in biochemistry, physiology, development, growth, and ultimately reproductive outputs. In our case, plants receive information about their neighbors through detecting changes in light quality through the phytochrome light receptors. This is a focus of the Maloof lab. You can read more generally about the way plants perceive these changes **[here](http://www.bioone.org/doi/full/10.1199/tab.0157)**. We want to understand how plants connect the upstream perception of environmental signals (in this case the presence of neighbors) and how this information cascades through the biological network of the organism to affect the downstream outputs of physiological and developmental changes. To get an approximation of what is going on in the biological network we need to work with an intermediate form of biological information: gene expression. Although there are important limitations to only using gene expression data which we will discuss during the lecture, it should provide some clues as to how to best connect the upstream environmental perception with the downstream growth outputs.

## Review
In the last section you learned about techniques to reduce our high-dimensional gene expression data by projecting them onto a simpler two dimensional representation. The axes of this projection describes the two largest axes of variation contained within the dataset. Each of these axes of variation is called a principle component (PC for short).  In our high-dimensional gene expression data set we can define the largest axes of variation in the dataset and plot them onto a 2D plane. 
K-means clustering allows us to search this higher dimensional space for patterns in the data, find the patterns, and assign cluster numbers to each gene in the dataset. When we combine PC plots with k-means plots we can assign a color value to each cluster like you did for exercise 8. We will now build on these ideas of data reduction and visualization to build a correlation based gene co-expression network. 

## Networks Intuition
In our example dataset from last time we used US cities to represent individual nodes that cluster together with one another based on **relationships** of geographic distances between each city. To put this in network terminology, each individual city is a **node**.

**(NY)**    

**(BOS)**   

**(DC)**

The relationships, or **edges**, between nodes were defined by measurements of geographic distance.

**(NY)--MILES--(BOS)**

**(NY)--MILES--(SF)**

## Repository

Clone the Assignment_8 repository

## Get started

Okay, let's load up our city data again and get started by playing with some examples!

The cities data is included in the Assignment 8 repo, but if you aren't taking BIS180L and need to download the file again, here is the address:

```bash
wget http://jnmaloof.github.io/BIS180L_web/data/us_cities.txt
```

Load the data into R. 


```r
cities <- read.delim("../data/us_cities.txt", row.names=1) # be sure to change the path
cities
```

```
##       BOS   NY   DC  MIA  CHI  SEA   SF   LA  DEN
## BOS     0  206  429 1504  963 2976 3095 2979 1949
## NY    206    0  233 1308  802 2815 2934 2786 1771
## DC    429  233    0 1075  671 2684 2799 2631 1616
## MIA  1504 1308 1075    0 1329 3273 3053 2687 2037
## CHI   963  802  671 1329    0 2013 2142 2054  996
## SEA  2976 2815 2684 3273 2013    0  808 1131 1307
## SF   3095 2934 2799 3053 2142  808    0  379 1235
## LA   2979 2786 2631 2687 2054 1131  379    0 1059
## DEN  1949 1771 1616 2037  996 1307 1235 1059    0
```


Take a look at the printed matrix. Imagine that we are an airline and want to calculate the best routes between cities. However, the planes that we have in our fleet have a maximum fuel range of only 1500 miles. This would put a constraint on our city network. Cities with distances greater than 1500 miles between them would no longer be reachable directly. Their edge value would become a zero.
Likewise, if two cities are within 1500 miles, their edge value would become 1. This 1 or 0 representation of the network is called the network **adjacency** matrix. 

let's create an adjacency matrix for our test dataset.


```r
cities_mat <- cities < 1500 # leave original matrix intact
diag(cities_mat) <- 0 # we do not have to fly within each of cities :)
cities_mat # check out the adjacency matrix
```

```
##      BOS NY DC MIA CHI SEA SF LA DEN
## BOS    0  1  1   0   1   0  0  0   0
## NY     1  0  1   1   1   0  0  0   0
## DC     1  1  0   1   1   0  0  0   0
## MIA    0  1  1   0   1   0  0  0   0
## CHI    1  1  1   1   0   0  0  0   1
## SEA    0  0  0   0   0   0  1  1   1
## SF     0  0  0   0   0   1  0  1   1
## LA     0  0  0   0   0   1  1  0   1
## DEN    0  0  0   0   1   1  1  1   0
```
**Exercise 1:**
Based on this 0 or 1 representation of our network, what city is the most highly connected? *Hint: sum the values down a column OR across a row for each city*

Try extending the range to 2000 miles in the above code (place the adjacency matrix in an object `cities_mat_2000`. Does the highest connected city change? If so explain. 




##Plotting networks
Now plot this example to see the connections based on the 2000 mile distance cutoff. It should show the same connections as in your adjacency matrix. 


```r
library(igraph) # load package
# make sure to use the 2000 mile distance cutoff 
cities_graph2 <- graph.adjacency(cities_mat_2000, mode = "undirected")
plot.igraph(cities_graph2)
```

![plot of chunk plotigraph1]({{ site.baseurl }}/figure/plotigraph1-1.png)
**Exercise 2:**
What is the total number of nodes in the plot? 
What is the total number of edges in the plot?

**Exercise 3:**
Re-calculate the adjacency matrix with the cutoff value at 2300. Calculate the number of edges using the following code. What do you get?


```r
sum(cities_mat_2300)/2 # divide by 2 because the matrix has 2 values for each edge
```
This 1 or 0 representation of the network is a very useful simplification that we will take advantage of when trying construct biological networks. We will define each gene as a node and the edges between the nodes as some value that we can calculate to make an adjacency matrix. 

**(Gene1)**    

**(Gene2)**    

**(Gene3)**

**(Gene1)--Value?--(Gene2)**

We do not have geographic distance between genes, but we do have observations of each gene's relative expression values across the Genotype by Environment by Tissue type combinations. We can use similarity in gene expression values to measure the biological distance between genes.  Genes that are expressed in more similar patterns should be closer.

A simple way to do this would be to calculate a correlation coefficient (a value between -1 and +1) between each gene with every other gene in our data set. The network would look like this for all gene pairs:

**(Gene1)--Correlation--(Gene2)**

There are **MANY** important caveats and limitations to this approach outlined **[here](http://www.nature.com/nrg/journal/v16/n2/full/nrg3868.html)**, but they still can be useful.

One problem with correlation-based networks is that the correlation coefficient can be effected by many things (including technical details of the experiment) that we don't care about.  A better choice is to the the **Mutual Correlation Ranks**, as explained [here](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2762411/).

To calculate the mutual ranks we take the following steps:

1. Compute the pairwise correlation coefficient for all gene pairs
2. For each gene, rank its correlation coefficients from highest to lowest.
3. Note that the ranks computes in step 2 are not necessarily symmetric.  So, for each gene pair compute the (geometric) average of ranks.

Once we have done this, our network will look like this for all gene pairs:

**(Gene1)--MutualRank--(Gene2)**

Let's get started.

Based on the pattern that we observed in our clustering analysis on Tuesday and further analysis, the leaf samples that appeared to be part of their own cluster (especially in the heat map) were bad libraries. **This demonstrates the importance of visualizing your data as often as possible during an analysis to catch potential errors.** We will remove these libraries from our analysis today.

Either copy the gene expression file from Assignment_7 to your assignment_8 directory or re-download:

```bash
wget http://jnmaloof.github.io/BIS180L_web/data/voom_transform_brassica.csv
```

Load the data into R

```r
library(tidyverse)
# make sure to change the path to where you downloaded this using wget

# make sure to change the path to where you downloaded this using wget
brass_voom_E <- read_csv("../data/voom_transform_brassica.csv")
brass_voom_E <- brass_voom_E[,-c(38,42,46)] # remove questionable library columns
head(brass_voom_E)
```

We will use the 300 genes showing the most variance across samples in the data set.

```r
brass_voom_E$variance <- apply(brass_voom_E[,-1],1,var)

gene_exp300 <- brass_voom_E %>% filter(rank(desc(variance)) <= 300) %>% select(-variance) %>% column_to_rownames("GeneID") %>% as.matrix()

head(gene_exp300[,1:6])
```

```
##           IMB211_DP_1_INTERNODE IMB211_DP_1_LEAF IMB211_DP_1_PETIOLE
## Bra000059           6.008547559        -1.842657            7.643936
## Bra000441          -0.293202654         4.392560            2.161185
## Bra000615           8.199095650        -3.427619            3.948964
## Bra000638           8.403764872        -3.427619            5.137168
## Bra000815          -0.003696037        -3.427619           -1.981773
## Bra001986          11.287212959        -1.105691            5.073509
##           IMB211_DP_1_SILIQUE IMB211_DP_2_INTERNODE IMB211_DP_2_LEAF
## Bra000059           -1.746994              7.620447        -3.597011
## Bra000441           -1.162031             -1.601140         3.184349
## Bra000615            7.491411              8.081854        -1.275083
## Bra000638            4.308289              8.591153        -3.597011
## Bra000815           10.022844             -1.601140        -2.012048
## Bra001986            9.161399             11.097781        -0.789656
```

To Illustrate the process let's begin with just 5 genes
Subset the data to just five genes

```r
gene_exp5 <- gene_exp300[1:5,]
```

Create correlation matrix

```r
gene_exp5_cor <- cor(t(gene_exp5))
gene_exp5_cor %>% round(3)
```

Set the diagonal to 0:

```r
diag(gene_exp5_cor) <- 0
gene_exp5_cor
```


Rank the correlations for each gene.  We will use the absolute correlation value, so + or - correlations will be treated the same.  This will lead to an __unsigned__ network.

```r
gene_exp5_rank <- apply(gene_exp5_cor,2,function(x) rank(-abs(x)))
gene_exp5_rank
```

**Exercise 4:**
(**A**) Describe what is meant by the "1" in the ["Bra000059", "Bra000441"] cell.

(**B**) Do ["Bra000059", "Bra000441"] and ["Bra000441", "Bra000059"] have different values?  If so, why?

Now compute the pairwise mutual ranks (aka average ranks):

```r
gene_exp5_MR <- sqrt(gene_exp5_rank * t(gene_exp5_rank))
gene_exp5_MR
```

(**C**) Do ["Bra000059", "Bra000441"] and ["Bra000441", "Bra000059"] have different values in the MR tables?  Why or why not?

We next need to construct an adjacency matrix of this gene network.  To do so, let's put some constraints on what we want to call an edge. In this case let's only place edges between genes when there mutual rank is 2 or less.

**Exercize 5:**
(**A**) _Create the adjacency matrix described above and place it in an object called `genes_adj_MR2`.  It should look like this:_

```
##           Bra000059 Bra000441 Bra000615 Bra000638 Bra000815
## Bra000059         0         1         0         1         0
## Bra000441         1         0         0         0         0
## Bra000615         0         0         0         1         1
## Bra000638         1         0         1         0         0
## Bra000815         0         0         1         0         0
```

(**B**) Which genes are connected to Bra000615?

Okay, I think now that we have the basic concepts, let's work with the larger gene expression data set. 


**Exercise 6:**

(**A**)  
__Working with the the full `gene_exp300` matrix__, create an adjacency matrix called `genes_adj_MR4` for the genes use a cutoff of MR < =  4.  Remember to set the diagonal of the adjacency matrix to 0.  Create a second adjacency matrix `genes_adj_MR10` using a cutoff of of MR < =  10.



(**B**)
Now we can do some calculations. If our cutoff is MR4, how many edges do we have in our 300 node network? What if we increase our cutoff to MR10? *hint: sum( )*



**Exercise 7:**
Use the following code to plot our networks using different thresholds for connectivity. What do the colors represent?  What patterns do you see in the visualization of this data? __You will need to click on the zoom button on the plot to be able to visualize this well.__



```r
gene_graphMR4 <- graph.adjacency(genes_adj_MR4, mode = "undirected") #convert adjacency to graph
comps <- clusters(gene_graphMR4)$membership                        #define gene cluster membership
colbar <- rainbow(max(comps)+1)                                   #define colors
V(gene_graphMR4)$color <- colbar[comps+1]                          #assign colors to nodes
plot(gene_graphMR4, layout = layout_with_kk, vertex.size = 4, vertex.label = NA)
  
gene_graphMR10 <- graph.adjacency(genes_adj_MR10, mode = "undirected") #convert adjacency to graph
comps <- clusters(gene_graphMR10)$membership                        #define gene cluster membership
colbar <- rainbow(max(comps)+1)                                   #define colors
V(gene_graphMR10)$color <- colbar[comps+1]                          #assign colors to nodes
plot(gene_graphMR10, layout = layout_with_kk, vertex.size = 4, vertex.label = NA)
```

##Graph Statistics for Network Comparison
Graph density is a measure of the total number of edges between nodes out of the total possible number of edges between nodes. It is a useful metric if you want to compare two networks with a similar number of nodes. We could have split our data into the two treatments (DP and NDP) at the beginning of our analysis, built separate networks for each, then used metrics like this to compare the network properties between treatments. 

Another really cool property of graphs is we can ask how connected any two nodes are to one another by performing a path analysis through the network. Think about the cities network. If we wanted to get from BOS to SF but we had our plane fuel constraints we could not fly between the two cities on a direct flight. We will have to settle for a layover. A path analysis can find the flight path between cities connecting BOS and SF in the shortest number of layovers. In a biological context it is a little more abstract, but we are asking the network if there is a way that we can get from gene A to gene B by following the edges in the network. Plotting this will help understand!

**Exercise 8:**
 The functions `graph.density()` and `average.path.length()` compute the graph density and average path length (big surprise.  Use these functions to determine which graph (MR4 or MR10) has the greater density and the greater average path length.  Are the results what you expected?


Now let's plot the distance between two specific nodes. Rather annoyingly `igraph` does not have an easy way to input gene names for the path analysis. It requires that you provide the numeric row number of gene A and how you want to compare that to the column number of gene B. I have written this additional piece of code to show you how this works. We get the shortest paths between ALL genes in the network and then print the results. We are interested in visualizing the path between Bra029719 (row number 227) and Bra019098 (column number 43). This is where the 227 and 43 arguments come from in *get.shortest.paths()*


```r
gene_graphMR10 <- graph.adjacency(genes_adj_MR10, mode = "undirected")
distMatrix <- shortest.paths(gene_graphMR10, v = V(gene_graphMR10), to = V(gene_graphMR10))
head(distMatrix)[,1:7]

pl <- get.shortest.paths(gene_graphMR10, 227, 43)$vpath[[1]] # pull paths between node 132 and 45

V(gene_graphMR10)[pl]$color <- paste("green")          # define node color
E(gene_graphMR10)$color <- paste("grey")               # define default edge color
E(gene_graphMR10, path = pl)$color <- paste("blue")    # define edge color
E(gene_graphMR10, path = pl)$width <- 10               # define edge width
plot(gene_graphMR10, layout = layout_with_kk, vertex.size = 6, vertex.label = NA)
```

You will need to click on the zoom button on the plot to be able to visualize this well.

**Exercise 9:**
Using what you know about graphs, repeat the analysis for the smaller cities matrix. Show your code to answer these questions.
What is the graph density of the cities network with a 1500 mile flight range?
What is the average path length of the cities network with a 1500 mile flight range?
Find the shortest path between SEA and DC with 1500 mile flight range. Graph it.
Find the shortest path between SEA and DC with 2300 mile flight range. Graph it.

You have just done some complex analysis of networks. There are many more ways to think about this type of data. I hope that you can see the usefulness of this abstraction of the biological data. If you are interested in networks I recommend reading the igraph documentation. It has a lot of good information and citations for the theory of networks. 

If you want to pursue more advanced methods of gene network construction, one that performs well and has excellent documentation and tutorials is Weighted Gene Correlation Network Analysis.  It is similar to what we did here but uses more sophisticated methods for determining correlations and cutoff thresholds.  [WGCNA website](https://labs.genetics.ucla.edu/horvath/htdocs/CoexpressionNetwork/Rpackages/WGCNA/)

