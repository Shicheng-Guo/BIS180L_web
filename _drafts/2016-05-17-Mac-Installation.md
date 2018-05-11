---
title: "Installing Requisite Software on your Mac"
layout: post
tags:
hidden: 
---

If you want to try doing the labs directly on your Mac instead of on AWS here is how you can.

## web downloads

Install the following packages by clicking on the link and following the instructions on the web page:

* [Xcode](https://developer.apple.com/xcode/download/), allowing compilation of source packages on your Mac.
* The [atom](https://atom.io/) editor
* The [R](https://cran.r-project.org/) statistical programming language
* The R IDE [Rstudio](https://www.rstudio.com/)
* The sequence alignment viewer [jalview](http://www.jalview.org/)
* The network viewer [cytoscape](http://www.cytoscape.org/)

## Atom packages

Open up at atom, click on File > Preferences, and then install the following atom packages.  Not all of these are needed for the BIS180L but they are good to have

* Sublime-Style_Column-Selection
* autocomplete-python
* git-control
* language-r
* language-markdown
* markdown-pdf
* markdown-toc
* markdown-preview
* python-tools
* r-exec

## Homebrew

Install [Homebrew](http://brew.sh/), a package manager for OS X that it much easier to install Linux/Unix packages.  There are some reports that homebrew has issues on El Capitan, but that may have been resolved.  Let me know if you get data one way or the other.

From a terminal window:

upgrade homebrew

    brew update
    brew upgrade

install the following packages through homebrew

    #brew tap homebrew/science # deprecated?
    brew tap brewsci/bio # additional packages
    brew install htop
    brew install git
    brew install igv
    brew install clustal-w
    brew install kalign
    brew install t-coffee
    brew install muscle
    brew install mafft
    brew install tophat
    brew install bwa
    brew install cufflinks
    brew install samtools
    brew install bedtools
    brew install blast
    brew install emboss

## R packages

Open R and then

    install.packages(c("swirl","ggplot2","genetics","LDheatmap","hwde","GenABEL","seqinr","qtl"))
    install.packages(c("evaluate","formatR","highr","markdown", "yaml","htmltools","caTools","bitops","knitr","rmarkdown"))
    install.packages("devtools")
    install.packages("shiny")
    install.packages("rsconnect")
    devtools::install_github(repo = "cran/PSMix")
    install.packages(c("pvclust","gplots","cluster","igraph","scatterplot3d","ape","SNPassoc"))

Still within R, install bioconductor

    source("http://bioconductor.org/biocLite.R")
    biocLite()
    biocLite("edgeR")
    biocLite("VariantAnnotation")

## perl modules

For auto_barcode to work, the following must be installed (From the Unix command line):

    sudo cpan install Statistics::Descriptive
    sudo cpan install Statistics::R
    sudo cpan install Text::Levenshtein::XS
    sudo cpan install Text::Table

## Other

Still need to deal with trimmomatic and auto_barcode, but the instructions in the labs should more or less work.



