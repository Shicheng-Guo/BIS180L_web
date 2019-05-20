---
layout: lab
hidden: true
title: Differential Gene Expression from Illumina RNAseq
output: html_document
tags:
- R
- Brassica
- Illumina
- RNAseq
---



## Background

Differential expression analysis is a powerful tool in genomics.  The goal is to detect transcripts that are present at different levels in different samples.  Samples could be diseased versus healthy tissue, individuals treated with a drug versus controls, individuals from different populations, etc.  The determination and subsequent analysis of genes that are differentially expressed can give insight into the biological processes affected by the disease/treatment/population, or whatever factor(s) are being used to contrast the samples. 

The principle behind determining which genes are differentially expressed is similar to that for other hypothesis-based tests such as ANOVA or t-tests.  We will call genes differentially expressed if the mean expression between treatments is larger than would be expected by chance given the amount of variance among replicates within a treatment type.  However there are several important issues to consider: the first is multiple testing.  Imagine doing a t-test for differential expression on 30,000 genes.  At p < .05 you would expect 5% (600!) of the genes to be called as significantly different by random chance.  This is known as the multiple testing problem and the p-values must be adjusted to compensate for the large number of tests.  Second there are typically very few replicates per treatment reducing power; thankfully techniques have been developed to “share” information between genes to somewhat deal with this issue.  Third, the methods developed for microarray analysis are not directly applicable. Log-transformed microarray data can be effectively modeled as normally distributed.  In contrast RNAseq data is count data and therefore has a different (non-normal) numerical distribution. Consequently statistical models require a different error distribution.

At first glance one might think that the [Poisson distribution](http://en.wikipedia.org/wiki/Poisson_distribution) would be an appropriate model for RNAseq data: reads are discrete events and the chance of a read landing in any particular gene is very low.  Indeed Poisson models were originally tried.  However, in the Poisson distribution the expected mean and variance should be equal.  For most RNAseq data this is not true; the data is over-dispersed: the variance is larger than the mean.  Alternatives are the [Negative Binomial](http://en.wikipedia.org/wiki/Negative_binomial_distribution) and Quasi-Poisson models.

It is important to consider an appropriate measure of expression and normalization.  Normalization is important: if you have a total of 10,000,000 reads from 1 sample and 5,000,000 reads from another sample clearly an adjustment for the total number of reads (a.k.a library size) must be done.  While some favor RPKM (Reads per kilobase exon length per million reads mapped), for finding DE genes it is better to normalize counts between samples using a different method (discussed below) and to not adjust for gene length.  Why?  1) the number of reads is not always a linear function of gene length. 2) dividing by gene length causes a loss of information.  By RPKM a gene of 1kb with 10 counts would be treated the same as a 100bp gene with 1 count, but clearly we are much more confident of the expression level when we have 10 counts instead of 1.  This information is lost in RPKM.

Regarding normalization between samples, genes with very high expression levels can skew RPKM type normalization.  Consider two samples where gene expression is the same except that in the first sample RUBISCO is expressed at a very high level, taking up half of the reads.  In the second sample RUBISCO is expressed at a lower level, accounting for 25% of the reads.  By RPKM all non RUBISCO genes will appear to be expressed more highly in the second sample because RUBISO “takes up” fewer reads.  Methods such as [TMM normalization](http://genomebiology.com/2010/11/3/R25) can account for this.

Two packages that effectively deal with the above issues are [DESeq](http://bioconductor.org/packages/release/bioc/html/DESeq.html) and [edgeR](http://www.bioconductor.org/packages/release/bioc/html/edgeR.html), both available through [Bioconductor](http://bioconductor.org/).  Both are recommend.  We will use edgeR for today's exercises.  

If you are going to do your own RNAseq analyses at some later time, I __strongly recommend__ that you thoroughly study the [edgeR user manual](http://www.bioconductor.org/packages/release/bioc/vignettes/edgeR/inst/doc/edgeRUsersGuide.pdf) available both at the [link](http://www.bioconductor.org/packages/release/bioc/vignettes/edgeR/inst/doc/edgeRUsersGuide.pdf) and by typing `edgeRUsersGuide()` in R (after you have loaded the library).


## Set your working directory

Pull your Assignment_6 repository and set it as your working directory in R.

You can open the `Assignment_6_Part_1.Rmd` file there to record you answers.

## GFF to GTF

There are two closely related file formats that describe genomic features (like where genes, introns, and exons are in the genome), [GFF](http://www.sequenceontology.org/gff3.shtml) and [GTF](http://mblab.wustl.edu/GTF22.html).  Unfortunately we have a GFF but we need a GTF.  Fortunately the conversion is pretty easy.

Remember that the reference files are in the `Assignment_5_Last.First/Brapa_reference` .  Create a symbolic link called `Brapa_reference` in the Assignment_6 directory that points to the original `Brapa_reference` directory (you can review how to so this in the Linux tutorial from the first week).


```r
library(tidyverse)
library(rtracklayer)
gff <- import.gff("Brapa_reference/Brapa_gene_v1.5.gff")
gff #take a look

#create a column "gene_id" that contains the gene name for every entry
gff$gene_id <- ifelse(is.na(gff$ID),gff$Parent,gff$ID)

export(gff,"Brapa_reference/Brapa_gene_v1.5.gtf",format="gtf")
```



## Bam to read counts

As you know from last week's lab, we mapped RNAseq reads to the _B. rapa_ genome.  In order to ask if reads are differentially expressed between cultivars (IMB211 vs. R500) or treatments (dense planting vs. non-dense planting) we need to know how many reads were sequenced from each gene.

To do this we use the bam files (telling us where in the genome the reads mapped) and the .gtf file that we just generated (telling us where the genes are) to figure out which reads belong to which genes.  Thankfully the `Rsubread` package does this for us.  An alternative workflow (not used here) would be to use the python package [`HTSeq`](http://www-huber.embl.de/HTSeq/).  Yet another alternative would have been to map our reads to cDNA fasta files and then use `samtools idxstats` on the bam file.

But for this lab we will use `Rsubread` on the two files from Thursday.  You will need to change the path listed below to make this work.  __Important: tilde expansion for your home directory will not work in this function.  Do not include a "~" in your path.  Use relative or the full absolute path__


```r
library(Rsubread)
readCounts <- featureCounts(
  files=c("../Assignment_5_Maloof.Julin/tophat_out-IMB211_All_A01_INTERNODE.fq/accepted_hits_A01.bam",
    "../Assignment_5_Maloof.Julin/tophat_out-R500_All_A01_INTERNODE.fq/accepted_hits_A01.bam"),
  annot.ext="Brapa_reference/Brapa_gene_v1.5.gtf", 
  isGTFAnnotationFile=TRUE,
  GTF.featureType="CDS", # This depends on GTF file.  Often it would be "exon"
  GTF.attrType="gene_id"
  )
```



__Exercise 1__  
Read the help file for `featureCounts()`.  Be sure to look at the section "Value" where it describes the output.  
__a__ Provide a line of code that displays the counts of the first 6 genes.  (It is not very interesting because the first genes in the file are on chromosome A03 (strange numbering...) and our bam file only has counts from A01...  )  
__b__ The gene `Bra011030` is on chromosome A01.  What are its read counts in the two files?  (Show code)
__c__ What percentage of reads (from each file) were assigned to a gene?  What percentage were unassigned because they were not located in a gene (aka "Feature")?  
__d__ What are 2 possible reasons why there are reads that cannot be assigned to a gene?  


## Finding differentially expressed genes with edgeR

The steps for finding differentially expressed genes are to:

1. Load the RNAseq counts.
2. Normalize the counts.
3. QC the counts.
4. Create a data frame that describes the experiment.
5. Determine the dispersion parameter (how over-dispersed is the data?)
6. Fit a statistical model for gene expression as a function of experimental parameters.
7. Test the significance of experimental parameters for explaining gene expression.
8. Examine results

### Get the counts data

We will study gene expression levels in _Brassica rapa_ internodes grown under two treatments, Dense Planting (DP) and Not Dense Planting (NDP).  We will study the response to DP in two cultivars, IMB211 and R500.  Click to download the [internode count data]({{site.baseurl}}/data/gh_internode_counts2.tsv).  This data set has 12 samples with counts of 40991 genes.

__Exercise 2__  
Move the downloaded data to your current working directory.

__a__. Create a new object in R called `counts.data` with the internode data.  (Use `read_tsv()` to import)
__b__. Check to make sure that the data looks as expected.  (What do you expect and how do you confirm?  Show your commands and output.)






```
## Parsed with column specification:
## cols(
##   gene_id = col_character(),
##   IMB211_DP_1_INTERNODE.1_matched.merged.fq.bam = col_double(),
##   IMB211_DP_2_INTERNODE.1_matched.merged.fq.bam = col_double(),
##   IMB211_DP_3_INTERNODE.1_matched.merged.fq.bam = col_double(),
##   IMB211_NDP_1_INTERNODE.1_matched.merged.fq.bam = col_double(),
##   IMB211_NDP_2_INTERNODE.1_matched.merged.fq.bam = col_double(),
##   IMB211_NDP_3_INTERNODE.1_matched.merged.fq.bam = col_double(),
##   R500_DP_1_INTERNODE.1_matched.merged.fq.bam = col_double(),
##   R500_DP_2_INTERNODE.1_matched.merged.fq.bam = col_double(),
##   R500_DP_3_INTERNODE.1_matched.merged.fq.bam = col_double(),
##   R500_NDP_1_INTERNODE.1_matched.merged.fq.bam = col_double(),
##   R500_NDP_2_INTERNODE.1_matched.merged.fq.bam = col_double(),
##   R500_NDP_3_INTERNODE.1_matched.merged.fq.bam = col_double()
## )
```

You may have noticed that the first gene_id is labelled "*".  These are the reads that did not map to a gene.  Let's remove this row from the data.  Also let's replace any "NA" records with "0" because that is what NA means in this case


```r
counts.data <- counts.data %>% filter(gene_id!="*")
counts.data[is.na(counts.data)] <- 0
```


__Exercise 3__  
The column names are too long.  Use the `str_replace()` command to remove the ".1_matched.merged.fq.bam" suffix from each column name.  Although it doesn't matter in this case, surrounding the "pattern" inside of the function `fixed()` would be a good idea,  because "." is a wildcard character.

When you are done, then typing `colnames(counts.data)` should give results below


```
##  [1] "gene_id"                "IMB211_DP_1_INTERNODE" 
##  [3] "IMB211_DP_2_INTERNODE"  "IMB211_DP_3_INTERNODE" 
##  [5] "IMB211_NDP_1_INTERNODE" "IMB211_NDP_2_INTERNODE"
##  [7] "IMB211_NDP_3_INTERNODE" "R500_DP_1_INTERNODE"   
##  [9] "R500_DP_2_INTERNODE"    "R500_DP_3_INTERNODE"   
## [11] "R500_NDP_1_INTERNODE"   "R500_NDP_2_INTERNODE"  
## [13] "R500_NDP_3_INTERNODE"
```

### Data exploration

__Exercise 4__  
__a.__ Make a histogram of counts for each of the samples.  
__b.__ Is the data normally distributed?  Make a new set of histograms after applying an appropriate transformation if needed.  

__Hint 1__: _You probably need to `gather` the data into long format.  See the Rice SNP lab and spread and gather tutorial if you need a review_.  __Hint 2__: _You can transform the axes in ggplot by adding_ `scale_x_log10()` or `scale_x_sqrt()` _to the plot.  One of these should be sufficient if you need to transform, but for other ideas see the [Cookbook for R page](http://www.cookbook-r.com/Graphs/Axes_%28ggplot2%29/#axis-transformations-log-sqrt-etc)_.  



For our subsequent analyses we want to reduce the data set to only those genes with some expression.  In this case we will retain genes with > 10 reads in >= 3 samples


```r
counts.data <- counts.data[rowSums(counts.data[,-1] > 10) >= 3,]
```

__Exercise 5:__  
We expect that read counts, especially from biological replicates, will be highly correlated.  Check to see if this is the case using the `pairs()` function and the `cor()` function.  Explain what each of these functions does and comment on the results.  

__Important Hint:__ _`pairs` is slow on the full dataset.  Try it on the first 1,000 genes.  Do you need to transform to make the pairs output more meaningful?_

__Important Hint2:__ _it will be hard to see the pairs plot in the Rstudio inline display.  Once you have the plot, click the expand to full window icon to display the plot in its own window.  Alternatively, instead of using all columns of data, try it on a smaller number of columns_

__Hint 3:__ _remember that you will need to remove the "gene_id" column before using the data in `pairs` or `cor`_



### Data normalization

In this section, we will normalize the counts data and determine how normalization influences the overall distribution of gene expression data. Data normalization is used in the analysis of differential gene expression using statistical models to account for differences in sequencing depth between samples, differences in the distribution of counts between different samples, and (sometimes) differences in the lengths of genes across the genome. Two commonly performed normalization methods used to analyze RNA seq data are RPKM (Reads per Kilobase per Million) and TMM (Trimmed Mean of M Values). We will use TMM in lab since TMM normalization is required for edgeR, and because RPKM is poorly behaved statistically. Normalized and non-normalized data will be visualized using box plots.

#### Assign Groups

Before we can normalize the data we need to be able to tell edgeR which groups the samples belong to.  Here group refers to the distinct sample types (i.e. combinations of genotype and treatment), not considering biorep.  In a later step we will need to tell edgeR our experimental design (the treatment and genotype relevant for each sample).  Here we create a data.frame with both group, genotype, and treatment info.  To do this we use the powerful search features of regular expressions.  There is a reasonable tutorial [here](https://bioinfomagician.wordpress.com/category/regular-expression/).  Regular expressions are a very important tool found in most computer languages, including the Linux shell, Perl, Python, and R.


```r
sample.description <- tibble(sample=colnames(counts.data)[-1])

sample.description <- sample.description %>% 
  #This next line searches for IMB211 or R500 in the colnames of counts.data and returns anything that matches
  #In this way we can extract the genotype info.
  mutate(gt=str_extract(sample,"R500|IMB211")) %>%
  
  #Now we use the same method to get the treatment
  mutate(trt=str_extract(sample,"NDP|DP")) %>%
  
  # Now we can paste the trt and gt columns together to give a group identifier

  mutate(group=str_c(gt,trt,sep = "_"))

sample.description

#next convert gt and trt into group variables (factors)

sample.description <- sample.description %>%
  mutate(gt=factor(gt), 
         trt=factor(trt,levels = c("NDP","DP"))) # setting the levels in this way makes "NDP" the refernce  

sample.description
```

#### Calculate normalization factors

Now we use the edgeR function `calcNormFactors()` to calculate the effective library size and normalization factors using the TMM method on our counts data.  First we create a DGEList object, which is an object class defined by edgeR to hold the data for differential expression analysis.  DGEList wants a numeric matrix as input, so need to convert our counts.data


```r
library(edgeR)
counts.matrix <- counts.data %>% select(-gene_id) %>% as.matrix()
rownames(counts.matrix) <- counts.data$gene_id

dge.data <- DGEList(counts=counts.matrix, 
                    group=sample.description$group)
dim(dge.data) 
dge.data <- calcNormFactors(dge.data, method = "TMM")
dge.data$samples # look at the normalization factors
```

#### Make a plot of the Biological Coefficient of Variation of each sample

Statistically significant differential expression is assessed based on variance within and between treatments. We can partition the variance between replicate RNA samples into two sources: **technical variance** and **biological variance**. 

Technical variance usually decreases as the number of total gene counts increases. Biological variance, however, will not change even if total library size increases. One way of analyzing the variation in a data set is to look at the coefficient of variation (CV), or the variation related to the average value of the whole population (of genes in this case).  CV is calculated as standard deviation divided by the mean.  We can also look at the CV of the biological variance, or BCV.  A reliable estimate of the Biological Coefficient of Variation is required for realistic assessment of differential expression in RNA-seq experiments.

We can use the BCV to calculate the distance between samples based on their gene expression.  Similar to the SNP data set we have a high dimension data set.  Like the SNP data set we can use multi-dimensional scaling to plot the gene expression distances in 2 dimensions.



```r
plotMDS(dge.data, method = "bcv") 
```

![plot of chunk MDS]({{ site.baseurl }}/figure/MDS-1.png)

__Exercise 6__  
Discuss the MDS plot.  Does it give you confidence in the experiment or cause concern?

__Exercise 7__  

We can extract the normalized data with:


```r
counts.data.normal <- cpm(dge.data)
```

To get a graphical idea for what the normalization does, make box plots of the count data for each sample before and after normalization.  Discuss the effect of normalization.

__Hint 1__: _log2 transform the counts before plotting.  Add a value of "1" before log2 transforming to avoid having to take the log2 of 0.  Your transformation will look something like this:


```r
counts.data.log <- log2(counts.data[,-1] + 1)
```

__Hint 2__: _If you don't want to bother with gathering your data before going to ggplot, you can just use the `boxplot()` function and feed it the (transformed) matrix directly._

__Hint 3__: Why do I use `[,-1]` above?  Do you need to use this on `counts.data.normal`?




#### Calculate dispersion factors

Dispersion, or spread of the data, describes how “squeezed” or “broad” a distribution is. In a negative binomial distribution (as is used for sequence count data), the BCV is the *square root of the dispersion of the negative binomial distribution*. You will calculate the tagwise dispersion in this section. The use of this tagwise (or gene-specific) dispersion is necessary to allow genes whose expression is consistent between replicates to be ranked more highly than genes that are not.  

EdgeR offers 3 ways to calculate dispersion: Common, Trended, and Tagwise.  To calculate dispersion, we need to set up a model of our experiment (aka the Design). The output plot graphs the Biological Coefficient of Variation (BCV) on the y-axis, relative to gene expression level on the x-axis.  Each type of dispersion value is indicated on the `plotBCV()` graph.  An empirical Bayes strategy is used to squeeze the dispersion of all genes toward the common dispersion.  

First we tell edgeR about our full experimental design.

```r
design <- model.matrix(~gt+trt,data = sample.description)
rownames(design) <- sample.description$sample
design
```

```
##                        (Intercept) gtR500 trtDP
## IMB211_DP_1_INTERNODE            1      0     1
## IMB211_DP_2_INTERNODE            1      0     1
## IMB211_DP_3_INTERNODE            1      0     1
## IMB211_NDP_1_INTERNODE           1      0     0
## IMB211_NDP_2_INTERNODE           1      0     0
## IMB211_NDP_3_INTERNODE           1      0     0
## R500_DP_1_INTERNODE              1      1     1
## R500_DP_2_INTERNODE              1      1     1
## R500_DP_3_INTERNODE              1      1     1
## R500_NDP_1_INTERNODE             1      1     0
## R500_NDP_2_INTERNODE             1      1     0
## R500_NDP_3_INTERNODE             1      1     0
## attr(,"assign")
## [1] 0 1 2
## attr(,"contrasts")
## attr(,"contrasts")$gt
## [1] "contr.treatment"
## 
## attr(,"contrasts")$trt
## [1] "contr.treatment"
```

This has created a design matrix where each row represents one sample and each column represents a factor in the experiment.  The "1"s indicate that a particular factor applies to a sample.  In this design we have a coefficient to indicate the genotype and a coefficient to indicate the treatment.

Now we estimate the dispersions

```r
#First the overall dispersion
dge.data <- estimateGLMCommonDisp(dge.data,design,verbose = TRUE)

#Then a trended dispersion based on count level
dge.data <- estimateGLMTrendedDisp(dge.data,design)

#And lastly we calculate the gene-wise dispersion, using the prior estimates to "squeeze" the dispersion towards the common dispersion.
dge.data <- estimateGLMTagwiseDisp(dge.data,design)

#We can examine this with a plot
plotBCV(dge.data)
```

![plot of chunk dispersion]({{ site.baseurl }}/figure/dispersion-1.png)

You can see from the plot why you would not want to rely on the common dispersion!

### Find differentially expressed genes

Finally we are ready to look for differentially expressed genes.  We proceed by fitting a generalized linear model (GLM) for each gene.


```r
fit <- glmFit(dge.data, design)
```

The model fit above is the "full" model, including coefficients for genotype and treatment.  To look for differentially expressed genes we compare the full model to a reduced model with fewer coefficients. For example we could compare the full model to a model that removed the "genotype" term.  For genes where the simpler model fits as well as the full model we can conclude that the dropped term was not important.  Conversely, for genes fit significantly better by the full model we conclude that "genotype" was important.  The function to do this is `glmLRT()` which performs a likelihood ratio test between full and reduced model.

To find genes that are differentially expressed in R500 vs IMB211 we use


```r
gt.lrt <- glmLRT(fit,coef = "gtR500")
```

The differentially expressed genes can be viewed with `topTags()`


```r
topTags(gt.lrt) # the top 10 most differentially expressed genes
```

```
## Coefficient:  gtR500 
##                logFC   logCPM       LR        PValue           FDR
## Bra033098 -12.153105 6.070823 998.8289 3.227155e-219 7.756145e-215
## Bra023495 -11.889171 5.792298 974.5077 6.243784e-214 7.503155e-210
## Bra016271 -14.250692 8.144467 891.3678 7.385316e-196 5.916623e-192
## Bra020631 -11.318315 5.206858 870.7722 2.216677e-191 1.331890e-187
## Bra011216 -11.258770 5.133650 853.8519 1.057186e-187 5.081683e-184
## Bra020643 -14.383988 8.280736 841.0553 6.399981e-185 2.563619e-181
## Bra009785   7.950946 6.018503 786.8301 3.939704e-173 1.352669e-169
## Bra011765  -7.319947 6.341553 749.4443 5.299422e-165 1.592079e-161
## Bra026924  -8.334013 5.028260 729.9894 9.005222e-161 2.404795e-157
## Bra029392   8.339064 6.296476 723.1411 2.777440e-159 6.675300e-156
```

In the resulting table,

* logFC is the log2 fold-change in expression between R500 and IMB211.  So a logFC of 2 indicates that the gene is expressed 4 times higher in R500; a logFC of -3 indicates that it is 8 times lower in R500.
* logCPM is the average expression across all samples.
* LR is the likelihood ratio: L(Full model) / L(small model) .
* PValue: unadjusted p-value
* FDR: False discovery rate (p-value adjusted for multiple testing...this is the one to use)

To summarize the number of differentially expressed genes we can use `decideTestsDGE()`

```r
summary(decideTestsDGE(gt.lrt,p.value=0.01)) #This uses the FDR.  0.05 would be OK also.
```

```
##        gtR500
## Down     5487
## NotSig  13562
## Up       4985
```
In this table, the -1 row is the number of down regulated genes in R500 relative to IMB211 and the +1 tow is the number of up regulated genes.

If we want to create a table of all differentially expressed genes at a given FDR, then:

```r
#Extract genes with a FDR < 0.01 (could also use 0.05)
DEgene.gt <- topTags(gt.lrt,n = Inf,p.value = 0.01)$table

#save to a file
write.csv(DEgene.gt,"DEgenes.gt.csv")
```

It would be handy to plot bar charts of genes of interest.  Below is a function to do that.  Once the function is entered and sourced, we can use it to plot gene expression values.


```r
plotDE <- function(genes, dge, sample.description) {
  require(ggplot2)
  require(reshape2)
  tmp.data <- t(log2(cpm(dge[genes,])+1))
  tmp.data <- merge(tmp.data,sample.description,by.x="row.names",by.y="sample")
  tmp.data <- melt(tmp.data,value.name="log2_cpm",variable.name="gene")
  pl <- ggplot(tmp.data,aes(x=gt,y=log2_cpm,fill=trt))
  pl <- pl + facet_wrap( ~ gene)
  pl <- pl + ylab("log2(cpm)") + xlab("genotype")
  pl <- pl + geom_boxplot()
  pl + theme(axis.text.x  = element_text(angle=45, vjust=1,hjust=1))
}
```

With the function defined we can call it as follows:

```r
# A single gene
plotDE("Bra009785",dge.data,sample.description)

#top 9 genes
plotDE(rownames(DEgene.gt)[1:9],dge.data,sample.description)
```

__Exercise 8__  
__a__.  Find all genes differentially expressed in response to the DP treatment (at a FDR < 0.01).  
__b__.  How many genes are differentially expressed?  
__c__.  Make a plot of the top 9


### Gene by Treatment interaction

Examining the plots of the top gene regulated by treatment you will notice that several of the genes have a different response to treatment in IMB211 as compared to R500.  We might be specifically interested in finding those genes.  How could we find them?  We look for genes whose expression values are fit significantly better by a model that includes a genotype X treatment term.

The new model can be constructed as follows:

```r
design.interaction <- model.matrix(~gt*trt,data = sample.description)
rownames(design.interaction) <- sample.description$sample
design.interaction
```

```
##                        (Intercept) gtR500 trtDP gtR500:trtDP
## IMB211_DP_1_INTERNODE            1      0     1            0
## IMB211_DP_2_INTERNODE            1      0     1            0
## IMB211_DP_3_INTERNODE            1      0     1            0
## IMB211_NDP_1_INTERNODE           1      0     0            0
## IMB211_NDP_2_INTERNODE           1      0     0            0
## IMB211_NDP_3_INTERNODE           1      0     0            0
## R500_DP_1_INTERNODE              1      1     1            1
## R500_DP_2_INTERNODE              1      1     1            1
## R500_DP_3_INTERNODE              1      1     1            1
## R500_NDP_1_INTERNODE             1      1     0            0
## R500_NDP_2_INTERNODE             1      1     0            0
## R500_NDP_3_INTERNODE             1      1     0            0
## attr(,"assign")
## [1] 0 1 2 3
## attr(,"contrasts")
## attr(,"contrasts")$gt
## [1] "contr.treatment"
## 
## attr(,"contrasts")$trt
## [1] "contr.treatment"
```

__Exercise 9__:  
__a__. Repeat the dispersion estimates and model fit but with the new model.  Show code.  
__b__. How many genes show a significantly different response to treatment in IMB211 as compared to R500?  Save these genes to a file.  
__c__. Make a plot of the top 9 genes that have a significantly different response to treatment in IMB211 as compared to R500.  







## Next steps

Now that we know which genes are differentially expressed by their ID, what follow up questions would we like to pursue?

1. What types of genes are differentially expressed?  This can be asked at the individual gene level and also at the group level
2. What patterns of differential expression do we observe in our data?
3. Are there any common promoter motifs among the differentially expressed genes?  Such motifs could allow us to form testable hypotheses about the transcription factors responsible for the differential expression.
