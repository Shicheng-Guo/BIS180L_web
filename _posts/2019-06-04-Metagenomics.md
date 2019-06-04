---
layout: lab
hidden: true
title: 'Metagenomics'
tags:
- Linux
- Illumina
- Metagenomics
---

# Assignment 9: Metagenomics

## Background

Metagenomics is a rapidly expanding field with the power to explain microbial communities with a very high resolution by leveraging next generation sequencing data. There are applications in the clinic, ecological environments, food safety, and others. By definition, metagenomics is the study of a collection of genetic material (genomes) from a mixed community of organisms typically microbial.  

Today we will walk through a common metagenomics workflow using [QIIME2](www.qiime2.org) (pronounced "chime") and [phyloseq](https://joey711.github.io/phyloseq/index.html) by completing the following:

1. Determine the various microbial communities in our samples
2. Calculate the diversity within our sample (alpha diversity)
3. Calculate the diversity between different sample types (beta diversity)

*Acknowledgement must be paid to Professor Scott Dawson for sharing his original metagenomics lab that we have adapted for this class, to the Sundaresan Lab for sharing the data from their [publication](http://www.ncbi.nlm.nih.gov/pubmed/25605935), and to former TA Kristen Beck who wrote this version of the lab.*

## Clone your repository

Clone your Assignment_9 repository

+ cd into the repository
+ There will be an assignment template for today's lab.

## Install QIIME2
Quantitative Insights Into Microbial Ecology or [QIIME2](http://qiim2e.org/) is an open-source bioinformatics pipeline for performing microbiome analysis from raw DNA sequencing data. It has been cited by over 2,500 peer-reviewed journals since its [publication](http://www.nature.com/nmeth/journal/v7/n5/full/nmeth.f.303.html) in 2010.  

In terminal:


```bash
cd ~/Downloads
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash # change to the bash shell
bash Miniconda3-latest-Linux-x86_64.sh #run installer for conda
eval "$(/home/ubuntu/miniconda3/bin/conda shell.bash hook)"
```

When asked, answer "yes" to agree to the licence, "yes" to keep the default installation directory, and "yes" to initialize Miniconda3.

next, install qiime2

```bash
wget https://data.qiime2.org/distro/core/qiime2-2019.4-py36-linux-conda.yml
conda env create -n qiime2-2019.4 --file qiime2-2019.4-py36-linux-conda.yml

rm qiime2-2019.4-py36-linux-conda.yml
```

Now activate qiime2 (still in terminal)

```bash
conda activate qiime2-2019.4
source tab-qiime
```

Note: you must be in `bash` rather than `fish` to activate conda.  So, if you get an error `conda: command not found` then type `bash` followed by `eval "$(/home/ubuntu/miniconda3/bin/conda shell.bash hook)"`.


## Data

Switch to your `Assignment_9` directory


```bash
cd ~/Assignments/Assignment_9_Maloof.Julin
```

Download and unzip the data files:

```bash
wget http://jnmaloof.github.io/BIS180L_web/data/MetaGenomeData.tar.gz
tar -xvzf MetaGenomeData.tar.gz
```

We also need a reference file that has 16S sequences from different taxa, so that we can classify our reads

```bash
wget ftp://greengenes.microbio.me/greengenes_release/gg_13_5/gg_13_8_otus.tar.gz
```

now convert the reference files into a format that QIIME can use:

```bash
qiime tools import \
  --input-path gg_13_8_otus/rep_set/97_otus.fasta \
  --output-path 97_otus_sequences.qza \
  --type 'FeatureData[Sequence]'
  
qiime tools import \
  --input-path gg_13_8_otus/taxonomy/97_otu_taxonomy.txt \
  --output-path 97_otus_taxonomy.qza \
  --input-format HeaderlessTSVTaxonomyFormat \
  --type 'FeatureData[Taxonomy]'
```

## Background for our Data
Today, we will be working with the samples collected from the rhizosphere of rice plants. The rhizosphere is an area of soil near the plant roots that contains both bacteria and other microbes associated with roots as well as secretions from the roots themselves. See diagram below from [Phillppot et al., *Nature*, 2013](http://www.nature.com/nrmicro/journal/v11/n11/full/nrmicro3109.html).
![plot of rhizosphere]({{ site.baseurl }}/figure/metagenomics_lab-1-rhizosphere.jpg) 

In order to classify microbial diversity, metagenomics often relies on sequencing 16S ribosomal RNA which is the small subunit (SSU) of the prokaryotic ribosome. This region has a slow rate of evolution and therefore can be advantageous in constructing phylogenies. For this lab, samples for various soil depths and cultivars were sequenced with Illumina sequencing. The de-multiplexed reads that we will be working with are in `RiceSeqs.fna`, and the sample information is in `RiceMappingFile.txt`.


The naming conventions of the Sample IDs are a little abstract, so I have created a **quick reference** table for you here.

| Cultivar              | Source        |
|:----------------------|:-----------------|
| NE = Nipponbare Early | M = 1mm soil     |
| NL = Nipponbare Late  | B = root surface |
| I  = IR50             | E = root inside  |
| M  = M104             |                  |

\* Technical replicates are indicated with 1 or 2


## Explore and Quality Control Data
Often times, as bioinformaticians, we will receive data sets with little background. Sometimes the first step is to explore the raw data that we will be working with. This can help us spot inconsistencies or logical fallacies down the line when working with more automated pipelines.  

Open RiceMappingFile.txt with `less` to view more information about the data you are working with. This file contains information about each sample including the cultivar, treatment, and number of technical replicates. It also includes the barcodes used to identify each sample during multiplexing. Let's use the barcodes to determine if we have an similar number of reads per sample ID.  

In the RiceSeqs.fna file, barcodes for each sequence are indicated in the header with `new_bc=`. These barcodes are also mapped to the sample information in RiceMapping.txt. Try to determine the number of sequences present for each barcode. This can be accomplished using just Linux/Unix commands. I'll start by giving you the tools, so you can try to piece together the command on your own. 

**Helpful Commands (in no particular order):** `cut`, `grep`, `head`, `sort`, `uniq` and good 'ol `|` to chain the commands together.

If you get stuck, highlight the hidden text underneath this sentence for one potential solution to identifying the barcodes themselves.  
<font color="white" face="menlo">
grep ">" RiceSeqs.fna | cut -d " " -f 4 | sort | uniq -c
</font>

**Exercise 1:**
Using information in the RiceMappingFile.txt and RiceSeqs.fna answer the following questions. Are the number of sequences for each sample approximately the same or are there any outliers? If so, which samples do they belong to? Could a different number of sequences per sample affect future analysis? Explain your reasoning.

Now that we've poked around in our raw data, let's carry on with analyzing the microbes present in our samples.

## Import the data into QIIME2

We are using data that has already been partially processed from fastq files.  It has been trimmed and cleaned and converted into a ".fna" file.

Qiime keeps all data in .qza files.  We initiate such a file with our sequences using the command:


```bash
qiime tools import \
  --input-path Data/RiceSeqs.fna \
  --output-path Data/RiceSeqs.qza \
  --type 'SampleData[Sequences]'
```

## Dereplicate the sequences

The oddly named procedure of "dereplicating" counts the number of occurrences of each unique sequence in each of your sample.s


```bash
qiime vsearch dereplicate-sequences \
  --i-sequences Data/RiceSeqs.qza \
  --o-dereplicated-table Data/RiceTable.qza \
  --o-dereplicated-sequences Data/RiceRep-seqs.qza
```


## Cluster  Microbiome Sequences into OTUs
Operational taxonomical units (OTUs) are used to describe the various microbes in a sample. OTUs are defined as a cluster of reads with 97% 16S rRNA sequence identity. We will use QIIME to classify OTUs into an OTU table.

First we cluster similar sequences

```bash
qiime vsearch cluster-features-de-novo \
  --i-table Data/RiceTable.qza \
  --i-sequences Data/RiceRep-seqs.qza \
  --p-perc-identity 0.97 \
  --o-clustered-table Data/RiceTable-dn-97.qza \
  --o-clustered-sequences Data/RiceRep-seqs-dn-97.qza
```

Next, match these OTUs with the reference database so that we assign taxonomy:

(this will take about 15 minutes to run)

```bash
qiime feature-classifier classify-consensus-vsearch \
  --i-query Data/RiceRep-seqs-dn-97.qza \
  --i-reference-reads 97_otus_sequences.qza \
  --i-reference-taxonomy 97_otus_taxonomy.qza \
  --p-threads 2 \
  --o-classification Data/RiceTaxTable.qza
```


## Export data in a format that can be read by R phyloseq

We have to issue a separate table for each data type that we want to export

```bash
#table of otus
qiime tools export \
  --input-path Data/RiceTable-dn-97.qza \
  --output-path qiime_export
  
#convert otus to text format
biom convert -i qiime_export/feature-table.biom -o qiime_export/otu_table.txt --to-tsv

# table of taxonomy
qiime tools export \
  --input-path Data/RiceTaxTable.qza \
  --output-path qiime_export

# sequences
qiime tools export \
  --input-path Data/RiceRep-seqs-dn-97.qza \
  --output-path qiime_export
  

```

Let's view the statistics of the OTU table (a binary file) and save the output.


```bash
biom summarize-table -i qiime_export/feature-table.biom > qiime_export/otu_class.txt
```

**Exercise 2:**
From the OTU summary, look at how many OTUs correspond to each sample ("counts/sample detail"). Do technical replicates agree with one another? At this stage, what conclusions can you draw about the number of OTUs in these samples?  

## Import OTU table into R

We will use the R package [phyloseq](https://joey711.github.io/phyloseq/install.html) To analyze the OTU data.

First, install it (only needs to be done once).

In R:


```r
source('http://bioconductor.org/biocLite.R')
biocLite('phyloseq')
```
When asked "Update all/some/none? [a/s/n]:" you can choose "n"

Now bring data into R

```r
library(phyloseq)
library(tidyverse)
```



```r
otu <- read.delim("qiime_export/otu_table.txt", skip=1, row.names = 1, as.is = TRUE) %>% as.matrix()
head(otu)
```


```r
tax <- read.delim("qiime_export/taxonomy.tsv", as.is = TRUE) %>%
  select(-Confidence) %>%
  mutate(Taxon = str_remove_all(Taxon, ".__| ")) %>%
  separate(Taxon, into = c("domain", "phylum", "class", "order", "family", "genus", "species"), sep = ";")
rownames(tax) <- tax$Feature.ID
tax <- tax %>% select(-Feature.ID) %>% as.matrix()
tax[tax==""] <- NA
tax <- tax[rownames(otu),] #get the order of the two tables to be the same
head(tax)
```

create a data frame of sample info

```r
sampleinfo <- data.frame(sample=colnames(otu)) %>%
  mutate(cultivar=str_sub(sample,1,1),
         cultivar={str_replace(cultivar, "M", "M104") %>%
             str_replace( "I", "IR50") %>%
             str_replace( "N", "Nipponbarre")},
         time=str_extract(sample,"E|L"),
         location={str_extract(sample,".[12]") %>% str_sub(1,1)},
         location={str_replace(location, "B", "rhizoplane") %>%
             str_replace("M", "rhizosphere") %>%
             str_replace("E", "endosphere")})
rownames(sampleinfo) <- sampleinfo$sample
sampleinfo <- sampleinfo %>% select(-sample)
head(sampleinfo)
```


bring the OTUs and the taxonomy table together into one phyloseq object

```r
rice.ps <- phyloseq(otu_table(otu,taxa_are_rows=TRUE), tax_table(tax), sample_data(sampleinfo))
rice.ps
```

Do some filtering to remove rare sequences

```r
rice.ps.small <- filter_taxa(rice.ps, function(x) sum(x > 1) > 2, TRUE) #require greater than one observation in more than two samples
rice.ps.small
```

## Heatmap

As we learned last week, we can rely on the human eye to help pick out patterns based on color. We are going to make a heat map of the OTUs per sample. The OTU table is visualized as a heat map where each row corresponds to an OTU and each column corresponds to a sample. The higher the relative abundance of an OTU in a sample, the more intense the color at the corresponding position in the heat map. OTUs are clustered by [Bray-Curtis similarity](https://en.wikipedia.org/wiki/Bray?Curtis_dissimilarity).  For a refresher on biological classification, view this [helpful wiki page](http://en.wikipedia.org/wiki/Bacterial_taxonomy).  



```r
plot_heatmap(rice.ps.small)
```


**Exercise 3:**
Although, the resolution of the y-axis makes it difficult to read each OTU, it is still a valuable preliminary visualization. What types of information can you gain from this heat map? Are there any trends present at this stage with respect to the various samples?  

## Barplots

Now we'd like to visualize our data with a little higher resolution and summarize the communities by their taxonomic composition.  

Use the following command to generate a boxplot to describe our samples.  Here we are coloring by phylum, but we could use and level of taxonomic information

```r
plot_bar(rice.ps.small, fill="phylum")
```

a line separates every OTU, which leads to a lot of black.  We can get rid of the black lines with


```r
pl <- plot_bar(rice.ps.small, fill="phylum")
pl + geom_col(aes(fill=phylum, color=phylum))
```

This is a helpful visualization but what if you want to group the bar plots by cultivar or sample location?   Open the help page for `plot_bar` and work out how to do that.  (You may also want to look at the [phyloseq plot_bar tutorial](http://joey711.github.io/phyloseq/plot_bar-examples.html))

**Exercise 4:**  

__a.__ Make a bar plot with samples grouped by location.  When comparing by location, which groups are the predominant phyla in the different samples?  Are there any predominant groups unique to particular sample treatments?  

__b.__ Make a bar plot with samples grouped by cultivar.  When comparing by cultivar, are the predominant phyla consistent with those observed in Part A? Are there any predominant phyla unique to a specific cultivar? What does this indicate to you about the effect of the genotype and/or the effect of the treatment?  

Now that we know a little more information about the OTUs in our sample, we'd like to calculate the diversity within a sample --the alpha diversity-- and between our samples --the beta diversity.  

## Determine the Diversity Within a Sample
Alpha diversity tells us about the richness of species diversity within our sample. It quantifies how many taxa are in one sample and allow us to answer questions like "Are polluted environments less diverse than pristine environments?". 

There are more than two dozen different established metrics to calculate the alpha diversity. We will start with a small subset of methods. Feel free to read more details about other metrics [here](http://scikit-bio.org/docs/latest/generated/skbio.diversity.alpha.html).  

generate plots

```r
plot_richness(rice.ps, measures=c("Observed", "Chao1", "Shannon"))
```

**Exercise 5:**  
Is there an alpha diversity metric that estimates the sample diversity differently than the other metrics? If so, which one is it? 

**Exercise 6:**  
Look at the help file for `plot_richness` and plot the samples grouped either by cultivar or location.  Do either of these categories seem to affect species diversity?  Thinking back to the difference in read counts per sample, could the differences in diversity just be due to differences in sequencing depth?


## Visualize the Diversity Between Samples

The definition of beta diversity has become quite contentious amongst ecologists. For the purpose of this lab, we will define beta diversity as the differentiation amongst samples which is also the practical definition QIIME uses. To quantify beta diversity, we will calculate the pairwise Bray-Curtis dissimilarity, resulting in a distance matrix. For more information about other definitions/uses of beta diversity, see the [wikipedia page](http://en.wikipedia.org/wiki/Beta_diversity).


First compute the distances and compute MDS coordinates

```r
rice.ord.small <- ordinate(rice.ps.small, method="NMDS", distance="bray")
```

Now plot:

```r
pl = plot_ordination(rice.ps.small, rice.ord.small, type="samples", color="cultivar", shape="location") 
pl + geom_point(size=4)
```



**Exercise 7:**  

__a.__   Does cultivar or location appear to have more of an influence on the clustering?  

__b.__  Which two locations are more similar to one another?  Does that make biological sense?

The distance matrix generated for beta diversity can also be used to make UPGMA trees. UPGMA is a simple hierarchical clustering method and can be used to classify sampling units on the basis of pairwise similarities.  

**Exercise 8:**  

Four Nipponbarre samples form a distinct group separated from all other samples.  Replot the data (changing the plot aesthetics) to provide an explanation.
