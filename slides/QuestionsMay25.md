Questions May25
========================================================
author: 
date: 
autosize: true

How does Revigo take the GO values and P values to get the results? What is the relationship between these two values?
=====================
![GO example](../images/GO.png)
* The GO values are identifiers for specific ontology terms
* The p-values are whether specific GO terms are over-represented in our gene list

How does Revigo take the GO values and P values to get the results? What is the relationship between these two values?
=====================
* The GO values are identifiers for specific ontology terms
* The p-values are whether specific GO terms are over-represented in our gene list

Can you go over the TreeMap in REVIGO?
=====================
![revigo](../images/Revigo.png)

Are there any other ways to test if genes are differentially expressed other than the ones discussed in class? /  What is the difference between DESeq and edgeR? When would you use one over the other?
=====================
There are many different programs that do this.  See http://rnajournal.cshlp.org/content/22/6/839.long for a comparison of nine of the most popular ones.

I noticed the webpage with the motif information included the genomic sequence, and that some of the motifs had similar sequences. Although there was a motif that had the most enrichment, wouldn't it be possible for other motifs with a similar sequence to also be highly enriched? What could account for the difference of enrichment if the genomic sequences are so similar (assuming the function is also similar)?
=====================
Yes, multiple could be enriched

But...1bp mismatch really can make a difference...

List some common mistakes in the experiments, and what are ways to fix them?
=====================
* _library mixup / mislabelling._ This can be detected on the BCV plot and maybe fixed by sample swap...
* _poor experimental design._  Be sure to use proper randomization and blocking protocols.
* _poor library prep_ Practice!

How do you plot multiple variables in a histogram without melting?
=====================
Use a for loop to loop through the column names

```r
madeUpData <- as.data.frame(matrix(rnorm(600,mean = 10),ncol=6,dimnames=list(NULL,LETTERS[1:6])))
round(head(madeUpData),2)
```

```
      A     B     C     D     E     F
1  9.80  9.70 10.15  8.71 10.93 10.99
2 10.39  9.20 10.04 10.04 11.53  9.60
3 10.83  8.41 10.34 11.64 10.21  9.57
4 10.44 11.18  9.23  9.74  9.46 10.01
5  9.00  9.51 10.14 10.36 10.33 11.78
6  9.34 11.55 10.28  8.71 10.73 10.24
```

How do you plot multiple variables in a histogram without melting?
=====================
Use a for loop to loop through the column names

```r
for(col in colnames(madeUpData)) 
  hist(get(col,madeUpData),main=paste("histogram of",col))
```

![plot of chunk unnamed-chunk-2](QuestionsMay25-figure/unnamed-chunk-2-1.png)![plot of chunk unnamed-chunk-2](QuestionsMay25-figure/unnamed-chunk-2-2.png)![plot of chunk unnamed-chunk-2](QuestionsMay25-figure/unnamed-chunk-2-3.png)![plot of chunk unnamed-chunk-2](QuestionsMay25-figure/unnamed-chunk-2-4.png)![plot of chunk unnamed-chunk-2](QuestionsMay25-figure/unnamed-chunk-2-5.png)![plot of chunk unnamed-chunk-2](QuestionsMay25-figure/unnamed-chunk-2-6.png)

What is the difference between read.table vs read.delim? When can each be used?
=====================
`read.table` is a generic method for importing spreadsheets and you have to specify many of the options (like what the delimiter is).

`read.delim` essentially calls `read.table` but with options already filled in for a tab-delimited file.

`read.csv` essentially calls `read.table` but with options already filled in for a comma-delimited file.


For assignment 6, part 1, question 8a, how do you interpret the MDS plot?
=====================
![BCV](../images/edgeR_BCV.png)
* This plot shows the two main components of variation among samples.
* Samples that are closer together have more similar expression.
* So we hope that replicates are close and that conditions/treatments separate samples.

For assignment 6, part 1, question 8a, how do you interpret the MDS plot?
=====================
(repeat text in case cutoff on previous slide)
* This plot shows the two main components of variation among samples.
* Samples that are closer together have more similar expression.
* So we hope that replicates are close and that conditions/treatments separate samples.

For assignment 6, I don't understand how to read the dispersion plot and what it means?
=====================
![dispersion](../images/edgeR_Dispersion.png)
* each point is a gene
* y-axis is biological coefficient of variation ($ Std. Dev \div Mean), related to dispersion.
* x-axis expression level
* lines show "common" dispersion or dispersion trend by expression level

For assignment 6, I don't understand how to read the dispersion plot and what it means?
=====================
(repeat text in case cutoff on previous slide)
* each point is a gene
* y-axis is biological coefficient of variation ($ Std. Dev \div Mean), related to dispersion.
* x-axis expression level
* lines show "common" dispersion or dispersion trend by expression level

In what context would it be appropriate to use RPKM?
=====================

NEVER!

Just kidding...for visualization, especially if trying to compare between genes.

Could you briefly explain the difference between p-value and false discovery rate, and why FDR is preferred in the labs we're doing
=================================
incremental:true
* This goes back to multiple testing.  We are testing differnetial expression of 30,000 genes.
* Thought experiment: Take 6 replicates of the same genotype and treatment (say R500 in NDP) and arbitrarily split them into two groups and test for differential expression
* How many genes would be significant at 0.05?
* 30000 * 0.05 = 1,500!
* FDR corrects for this.
* FDR of 0.05 means that 5% of the genes at this significance level are expected to be false positives.

what does the 'sort=' argument do in merge() function
=====================
Try it both ways and look at the result! 

Or read the help!

Can you walk us through the coding or explain how the coding works for the dispersion models/ finding top 10 genes, etc? (assignment 6.1)
=====================

How is the genotype x treatment term in the last exercise of Assignment 6 Part 1 created?
=====================

Can you explain how the TMM normalization method works?
=====================
I will try to put something together for Tuesday

