---
layout: lab
title: Viewing Illumina reads in IGV; finding SNPs
hidden: true    <!-- To prevent post from being displayed as regular blog post -->
tags:
- Brassica
- Illumina
- Linux
---

# Goals

In the last lab period we learned about Illumina reads and fastq files.  We performed quality trimming and then mapped those reads to the _B. rapa_ reference genome.

Today we will pick up where we left off.  Our goals are to:

1. Learn about sequence alignment/mapping (SAM/BAM) files.
2. Examine mapped reads in [IGV--the integrative genomics viewer](https://www.broadinstitute.org/igv/).  This will allow us to see how reads are placed on the genome during the mapping process.
3. Find polymorphic positions in our sequencing data.


# Preliminaries

## Data files

For better viewing and SNP calling I compiled all of the IMB211 internode files and all of the R500 internode files and ran tophat on those.  Then to keep the download to a somewhat reasonable size I subset the bam file to chromosome A01.  Download the files as listed below:

    wget http://de.iplantcollaborative.org/dl/d/3A400919-4820-467A-8F9D-B80E6A6DD5C9/tophat_out-IMB211_All_A01_INTERNODE.fq.tar.gz
    tar -xvzf tophat_out-IMB211_All_A01_INTERNODE.fq.tar.gz

    wget http://de.iplantcollaborative.org/dl/d/B31CD90A-9B32-446A-A451-D0D645A91BC0/tophat_out-R500_All_A01_INTERNODE.fq.tar.gz
    tar -xvzf tophat_out-R500_All_A01_INTERNODE.fq.tar.gz

## IGV

Unfortunately the version of IGV installed on your computers does not work and it must be reinstalled.

Download the binary distribution from the [download page](https://www.broadinstitute.org/software/igv/download)

Unzip it and move the unzipped directory to BioinformaticsPackages

    unzip IGV_2.3.72.zip
    mv ~/Downloads/IGV_2.3.72 ~/BioinformaticsPackages/

Add the following line to the end of your `.bashrc` file

    PATH="$HOME/BioinformaticsPackages/IGV_2.3.52:$PATH"

Then source your `.bashrc`

    source .bashrc


## Examine tophat output

`cd` into one of the tophat output directories that you downloaded above

You will see several files there.  Some of these are listed below

* `accepted_hits.bam` -- A [bam](https://samtools.github.io/hts-specs/SAMv1.pdf) file for reads that were successfully mapped __(this is called accepeted_hits_A01.bam in the tophat output that I created for you since I only retained chromosome A01)__
* `unmapped.bam` A bam file for reads that were not able to be mapped __missing from the downloaded directory because I deleted it to save space__
* `deletions.bed` and `insertions.bed` [bed](https://genome.ucsc.edu/FAQ/FAQformat.html) files giving insertions and deletions
* `junctions.bed` A bed file giving introns
* `align_summary.txt` Summarizes the mapping

__Exercise 6__: Take a look at the `align_summary.txt` file.  
__a__.  What percentage of reads mapped to the reference?
__b__.  Give 2 reasons why reads might not map to the reference.

## Look at a bam file

Bam files contain the information about where each read maps.  There are in a binary, compressed format so we can not use `less` on its own.  Thankfully there is a collection of programs called [`samtools`](http://www.htslib.org/) that allow us to view and manipulate these files.

Let's take a look at `accepted_hits_A01.bam`.  For this we use the `samtools view` command

    samtools view accepted_hits_A01.bam | less

| Field | Value |
|-------|-------|
| 01 | Read Name (just like in the fastq) |
| 02 | Code providing info about the alighment.  |
| 03 | Template Name (Chromosome in this case) |
| 04 | Position on the template where the read starts |
| 05 | Phred based mapping quality for the read |
| 06 | CIGAR string providing information about the mapping |
| 10 | Sequence |
| 11 | Phred+33 quality of sequence |
| Additional fields | Varies; see SAM page for more info |

`samtools` has many additional functions.  These include

`samtools merge` -- merge BAM files  
`samtools sort` -- sort BAM files; required by many downstream programs  
`samtools index` -- create an index for quick access; required by many downstream programs  
`samtools idxstats` -- summarize reads mapping to each reference sequence  
`samtools mpileup` -- count the number of matches and mismatches at each position  

And more

## Look at a bam file with IGV

While `samtools view` is nice, it would be nicer to actually see our reads in context.  We can do this with [IGV, the Integrative Genome Viewer](https://www.broadinstitute.org/igv/)

To use IGV we need to create an index of our bam file

    samtools index accepted_hits_A01.bam

Then start IGV by typing

    igv.sh

Or by selecting it from the start menu > education

### Create a .genome file for IGV to use

By default IGV starts with the human genome.  It has a number of built-in genomes, but does not include _B. rapa_.  We must define it ourself.  This only needs to be done once per computer; IGV will remember it.

Click on Genomes > Create .genome file

Fill in the fields as follows:

* Unique Identifier: BrapaV1.5
* Descriptive name: Brassica rapa version 1.5
* FASTA file: (click on Browse and point to `BrapaV1.5_chrom_only.fa`)
* Cytoband file: (leave blank)
* Gene file: (click on Browse and point to the `Brapa_gene_v1.5.gff` file)
* Alias file: (leave blank)

### Load some tracks

Now to load our mapped reads:

Click on File > Load From File ; then select the `accepted_hits_A01.bam` file

Click on File > Load From File again ; then select the `junctions.bed` file

Click OK to index junctions.bed and OK again to sort it.

### Take a look

Click on the "ALL" button and select a chromosome A01.  Then zoom in until you can see the reads.

* Grey vertical bars are a histogram of coverage
* Grey horizontal bars represent reads.
    * Thin lines connect read segments that were split across introns.
    * Colored vertical lines show places where a read differs from the reference sequence.
* In the lower panel, the blue blocks and lines show the reference annotation
* The orange lines show junctions inferred by Tophat from our reads

__Exercise 7__:  
__a__ Can you distinguish likely SNPs from sequencing/alignment errors?  How?  
__b__ Go to A01:15,660,359-15,665,048 (you can cut and paste this into the viewer and press "Go".  For each of the the three genes in this region: does the annotation (in blue) appear to be correct or incorrect? If incorrect, describe what is wrong

## Calling SNPs

The goal of this section is to find polymorphisms between IMB211 and R500.  There are many tools available.  We will use [mpileup and bcftools](http://samtools.sourceforge.net/mpileup.shtml) part of the samtools suite.  [Additional Info](http://massgenomics.org/2012/03/5-things-to-know-about-samtools-mpileup.html)

Make a new directory for this analysis inside the Brassica_assigment directory

    mkdir SNP_analysis
    cd SNP_analysis

In the library preparation step there is a PCR amplification.  This can cause duplication of DNA fragments.  We want to remove these duplicate reads because they can skew our SNP analysis (essentially they represent pseudo-replication, giving us artificially high sample numbers).  We will use `samtools rmdup` to remove the duplicate reads

    samtools rmdup -s ../tophat_out-IMB211_All_A01_INTERNODE.fq/accepted_hits_A01.bam IMB211_rmdup.bam

    samtools rmdup -s ../tophat_out-R500_All_A01_INTERNODE.fq/accepted_hits_A01.bam  R500_rmdup.bam

Next create an index for each of the new files

    samtools index IMB211_rmdup.bam
    samtools index R500_rmdup.bam

Now we use `samtools mpileup` to look for SNPs.  Samtools mpileup calculates the number of reference and alternate alleles at each position in the genome and genotype likelihoods.  bcftools makes a call of the most likely genotype.

    samtools mpileup -DVuf ../Brapa_reference/BrapaV1.5_chrom_only.fa IMB211_rmdup.bam R500_rmdup.bam | bcftools view -vcg - > IMB211_R500.vcf

You should check the man page for the meaning of the flags, but briefly,

* for samtools,
    * -D and -V indicate that per sample depth and variant depth should be reported.  
    * -u is uncompressed format
    * -f specifies the reference fasta file.  
* For bcftools,
    * -c specifies that variants should be called.
    * -v limits the output to variant sites only
    * -g reports separate genotype calls for each sample


We will examine these in R either at the end of this lab or next period.

## Further info on SNP calling:

* Other mpileup flags [may be useful depending on your situation](http://samtools.sourceforge.net/mpileup.shtml).
* Realigning your reads around indels using the [GATK realigner](https://www.broadinstitute.org/gatk/guide/tooldocs/org_broadinstitute_gatk_tools_walkers_indels_IndelRealigner.php) is recommended.
* GATK offers an alternative and popular [genotyping pipeline and caller](https://www.broadinstitute.org/gatk/)
