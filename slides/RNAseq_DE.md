RNAseq: Differential Expression
========================================================
author: Julin Maloof
date: May 18, 2017
autosize: true
incremental: true

Goals
========================================================

Find genes that have different transcript levels:
* When comparing genotypes (IMB211, R500)
* When comparing treatments (low density (sun) and high density (shade))
* That respond differently to shade in the two genotypes.

Using RNAseq to quantify expression
========================================================

* In theory: simple.  
* Genes expressed at higher levels in the plants should generate more sequence fragments.
* Therefore we can count the number of reads mapping to a particular gene.
  - If IMB211 has more counts than R500 for a particlar gene, that may indicate higher expression


Challenges
========================================================

* RNAseq count data is not normally distributed
  - Cannot use Gaussian statistics because this is count data
  - Cannot use Poisson distribution because the data is "over dispersed"
  - Use a negative binomial distribution instead
* What if you have more overall reads in one library as compared to the other?
* What if one gene is expressed so highly in one sample that it dominates the read counts?
  - Need to normalize
* Small number of replicates (~ 3 per sample), large number of tests (30,000 - 40,000)
  - use Bayesian methods to "borrow" information among genes
  - Also need multiple testing correction

Don't be tempted by RPKM
========================================================

One common method of RNAseq quantification is Reads Per Kilobase of gene length per Million base pairs sequenced.

__Don't use it__ (at least for statistical analysis)

Problems:
* 1 read in a 100bp gene and 10 reads in a 1000bp gene both have the same RPKM.  (Why is this a problem?)
* Assumes that an uniform normalization is appropriate

Outline
======================================================

* Count number of reads in each gene for each sample (RSubread)
* Normalize read counts (EdgeR)
* Determine appropriate statistical models (EdgeR)
* Find differentially expressed genes (EdgeR)
* Examine results
