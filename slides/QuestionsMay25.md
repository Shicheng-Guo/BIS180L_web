QuestionsMay25
========================================================
author: 
date: 
autosize: true

Can you go over the TreeMap in REVIGO / How do you analyze the tree map?
=====================

Are there any other ways to test if genes are differentially expressed other than the ones discussed in class? /  What is the difference between DESeq and edgeR? When would you use one over the other?
=====================
There are many different programs that do this.  See http://rnajournal.cshlp.org/content/22/6/839.long for a comparison of nine of the most popular ones.


Can you explain how the TMM normalization method works?
=====================

For the final question of Assignment 6 part 2, I noticed the webpage with the motif information included the genomic sequence, and that some of the motifs in our data-set had similar sequences. Although there was a motif that had the most enrichment, wouldn't it be possible for other motifs with a similar sequence to also be highly enriched?Â What could account for the difference of enrichment if the genomic sequences are so similar (assuming the function is also similar)?
=====================

How does Revigo exactly take the GO values and P values to get the results? What is the relationship between these two values?
=====================

List some common mistakes in the experiments, and what are ways to fix them?
=====================
* _library mixup / mislabelling._ This can be detected on the BCV plot and maybe fixed by sample swap...
* _poor experimental design._  Be sure to use proper randomization and blocking protocols.
* _poor library prep_ Practice!

How do you plot multiple variables in a histogram without melting?
=====================
Use a for loop to loop through the column names

What is the difference between read.table vs read.delim? When can each be used?
=====================
`read.table` is a generic method for importing spreadsheets and you have to specify many of the options (like what the delimiter is).

`read.delim` essentially calls `read.table` but with options already filled in for a tab-delimited file.

`read.csv` essentially calls `read.table` but with options already filled in for a comma-delimited file.


For assignment 6, part 1, question 8a, how do you interpret the MDS plot?
=====================

Can you please go over the MDS plot from assignment 6 part 1?
=====================

Can you walk us through the coding or explain how the coding works for the dispersion models/ finding top 10 genes, etc? (assignment 6.1)
=====================

what does the 'sort=' argument do in merge() function
=====================
Try it both ways and look at the result! 

Or read the help!

How is the genotype x treatment term in the last exercise of Assignment 6 Part 1 created?
=====================

For assignment 6, I don't understand how to read the dispersion plot and what it means?
=====================

In what context would it be appropriate to use RPKM?
=====================

NEVER!

Just kidding...for visualization, especially if trying to compare between genes.

Could you briefly explain the difference between p-value and false discovery rate, and why FDR is preferred in the labs we're doing
=================================
* This goes back to multiple testing.  We are testing differnetial expression of 30,000 genes.
* Thought experiment: Take 6 replicates of the same genotype and treatment (say R500 in NDP) and arbitrarily split them into two groups and test for differential expression
* How many genes would be significant at 0.05?
* 30000 * 0.05 = 1,500!
* FDR corrects for this.
* FDR of 0.05 means that 5% of the genes at this significance level are expected to be false positives.

